//
//  JKPhotoToolBar.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKPhotoToolBar.h"
#import "JKPhoto.h"
#import "MBProgressHUD+JKExtension.h"
#import "JKTextFieldBtn.h"

@interface JKPhotoToolBar ()
{
    UILabel *_indexLabel;// 显示页码
    UIButton *_saveImageBtn;//下载按钮
    UITextView *_textView;//文字区域
    UIView * _toolView;//工具栏
}
@end

@implementation JKPhotoToolBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    //设置索引
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(20, 0, 100, 20);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    //设置文字区域
    _textView = [[UITextView alloc] init];
    [_textView setFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 70)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = [UIColor whiteColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_textView];
    //设置底部状态栏
    _toolView = [[UIView alloc]init];
    [_toolView setFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40)];
    _toolView.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolView];
    
    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 10, 20, 20)];
    [shareBtn setImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
    [_toolView addSubview:shareBtn];
    UIButton * collectBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 10, 20, 20)];
    [collectBtn setImage:[UIImage imageNamed:@"collectBtn"] forState:UIControlStateNormal];
    [_toolView addSubview:collectBtn];
    UIButton * messageBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130, 10, 20, 20)];
    [messageBtn setImage:[UIImage imageNamed:@"messageBtn"] forState:UIControlStateNormal];
    [_toolView addSubview:messageBtn];
    
    JKTextFieldBtn * textBtn = [[JKTextFieldBtn alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-150, 30)];
    [textBtn setTitle:@"请输入" forState:UIControlStateNormal];
    [textBtn setImage:[UIImage imageNamed:@"writeIcon"] forState:UIControlStateNormal];
    textBtn.layer.masksToBounds  = YES;
    textBtn.layer.cornerRadius = 10;
    textBtn.layer.borderWidth = 1;
    textBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [textBtn addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:textBtn];
    // 保存图片按钮
    //    CGFloat btnWidth = 30;
    //    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _saveImageBtn.frame = CGRectMake(20, 10, btnWidth, btnWidth);
    //    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    [_saveImageBtn setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateNormal];
    //    [_saveImageBtn setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateHighlighted];
    //    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:_saveImageBtn];
    
}

//- (void)saveImage{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        Photo *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
//}
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    if (error) {
//        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
//    } else {
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
//    }
//}
- (void)replyClick{
    if ([self.jkDelegate respondsToSelector:@selector(didClickReplyBtn:)]) {
        [self.jkDelegate didClickReplyBtn:self];
    }
}
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    JKPhoto *photo = _photos[_currentPhotoIndex];
    [_textView setText:photo.photoDescription];
}

@end
