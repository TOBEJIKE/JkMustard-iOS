//
//  JKPhotoView.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKPhotoView.h"
#import "JKPhoto.h"
#import "JKPhotoLoadingView.h"
#import "UIImageView+JKExtension.h"
#import "SDImageCache.h"
#import <QuartzCore/QuartzCore.h>
#define WEAK_OBJ(obj) __weak typeof(obj)     __weak_##obj__     = obj;
#define STRONG_OBJ(obj) __strong typeof ( __weak_##obj__  ) obj = __weak_##obj__;

@interface JKPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    JKPhotoLoadingView *_photoLoadingView;
}
@end

@implementation JKPhotoView

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        // 进度条
        _photoLoadingView = [[JKPhotoLoadingView alloc] init];
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
        [self addGestureRecognizer:longPressGesture];
        
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(JKPhoto *)photo {
    _photo = photo;
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage{
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        _photo.srcImageView.image = nil;
        __weak JKPhotoView *photoView = self;
        __weak JKPhoto *photo = _photo;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            photo.image = image;
            // 调整frame参数
            [photoView adjustFrame];
        }];
    } else {
        [self photoStartLoad];
    }
    // 调整frame参数
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        __weak JKPhotoView *photoView = self;
        __weak JKPhotoLoadingView *loading = _photoLoadingView;
        WEAK_OBJ(loading)
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize , NSInteger expectedSize) {
            STRONG_OBJ(loading)
            if (receivedSize > 0.001) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType , NSURL *imageUrl) {
            [photoView photoDidFinishLoadWithImage:image];
        }];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        if ([self.jkDelegate respondsToSelector:@selector(pictureViewImageFinishLoad:)]) {
            [self.jkDelegate pictureViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame{
    if (_imageView.image == nil) return;
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height-64;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 3.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    _imageView.frame = imageFrame;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
#pragma mark - 单击手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if ([self.jkDelegate respondsToSelector:@selector(pictureViewSingleTap:)]) {
        [self.jkDelegate pictureViewSingleTap:self];
    }
}
#pragma mark - 双击手势处理
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}
/** 根据手指位置计算zoomRect */
- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)touchPoint{
    CGRect zoomRect;
    zoomRect.size.height =  _imageView.frame.size.height / scale;;
    zoomRect.size.width  =  _imageView.frame.size.width / scale;;
    touchPoint = [self convertPoint:touchPoint toView:_imageView];
    zoomRect.origin.x    = touchPoint.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = touchPoint.y - ((zoomRect.size.height / 2.0));
    return zoomRect;
}
#pragma mark - 长按手势处理
- (void)handleLongPress:(UILongPressGestureRecognizer *)LongPress{
    if (LongPress.state == UIGestureRecognizerStateBegan) {
        if ([self.jkDelegate respondsToSelector:@selector(pictureViewLongPress:)]){
            [self.jkDelegate pictureViewLongPress:self];
        }
    }
}

@end
