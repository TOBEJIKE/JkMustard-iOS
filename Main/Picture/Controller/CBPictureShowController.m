//
//  CBPictureShowController.m
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBPictureShowController.h"
#import "JKPhotoView.h"
#import "JKPhotoToolBar.h"
#import "MBProgressHUD+JKExtension.h"
#import "CBHelperUI.h"

//#define kPhotoViewIndex(photoView) ([photoView tag] - 1000)

@interface CBPictureShowController ()<JKPictureViewDelegate,UIActionSheetDelegate,JKPhotoToolBarDelegate>{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    JKPhotoToolBar *_toolbar;
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    CBHelperUI * helpUI;
}
@end

@implementation CBPictureShowController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // 1.创建UIScrollView
    [self createScrollView];
    // 2.创建工具条
    [self createToolbar];
    // 3.创建返回按钮
    [self creatBackBtn];
}
- (void)creatBackBtn{
    helpUI = [[CBHelperUI alloc]init];
    [helpUI addImageViewWithFrame:CGRectMake(30, 40, 30, 30) withImageName:@"backBtn" target:self Event:@selector(backClick) inView:self.view];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建UIScrollView
- (void)createScrollView{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    frame.origin.x -= 10;
    frame.size.width += (2 * 10);
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

#pragma mark 创建工具条
- (void)createToolbar{
    _toolbar = [[JKPhotoToolBar alloc] init];
    _toolbar.backgroundColor = [UIColor clearColor];
    _toolbar.frame = CGRectMake(0, self.view.frame.size.height-140, self.view.frame.size.width, 140);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    _toolbar.jkDelegate = self;
    [self.view addSubview:_toolbar];
    [self updateTollbarState];
}
- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    for (int i = 0; i<_photos.count; i++) {
        JKPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    for (int i = 0; i<_photos.count; i++) {
        JKPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        // 显示所有的相片
        [self showPhotos];
    }
}
#pragma mark - PhotoView代理
- (void)pictureViewSingleTap:(JKPhotoView *)pictureView{
    if (_toolbar.hidden) {
        _toolbar.hidden = NO;
    }else{
        _toolbar.hidden = YES;
    }
}
- (void)pictureViewImageFinishLoad:(JKPhotoView *)pictureView{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}
- (void)pictureViewLongPress:(JKPhotoView *)pictureView{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self saveImage];
    }
}
- (void)saveImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JKPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

#pragma mark 显示照片
- (void)showPhotos{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+10*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-10*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (JKPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = ([photoView tag] - 1000);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index{
    JKPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[JKPhotoView alloc] init];
        photoView.jkDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * 10);
    photoViewFrame.origin.x = (bounds.size.width * index) + 10;
    photoView.tag = 1000 + index;
    
    JKPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSUInteger)index{
    if (index > 0) {
        JKPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        JKPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (JKPhotoView *photoView in _visiblePhotoViews) {
        if (([photoView tag] - 1000) == index) {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 循环利用某个view
- (JKPhotoView *)dequeueReusablePhotoView{
    JKPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    [self updateTollbarState];
}
#pragma mark photoToolBarDelegare
- (void)didClickReplyBtn:(JKPhotoToolBar *)photoToolBar{
    NSLog(@"回复按钮");
    //    ReplyViewController * reply = [[ReplyViewController alloc]init];
    //    [self.navigationController pushViewController:reply animated:YES];
}


@end
