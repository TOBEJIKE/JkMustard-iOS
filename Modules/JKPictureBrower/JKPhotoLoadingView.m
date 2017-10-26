//
//  JKPhotoLoadingView.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKPhotoLoadingView.h"
#import "JKPhotoProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface JKPhotoLoadingView ()
{
    UILabel *_failureLabel;
    JKPhotoProgressView *_progressView;
}
@end

@implementation JKPhotoLoadingView

- (void)setFrame:(CGRect)frame{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showFailure{
    [_progressView removeFromSuperview];
    if (_failureLabel == nil) {
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        _failureLabel.textAlignment = NSTextAlignmentCenter;
        _failureLabel.center = self.center;
        _failureLabel.text = @"网络不给力，图片下载失败";
        _failureLabel.font = [UIFont boldSystemFontOfSize:20];
        _failureLabel.textColor = [UIColor whiteColor];
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
}
- (void)showLoading{
    [_failureLabel removeFromSuperview];
    if (_progressView == nil) {
        _progressView = [[JKPhotoProgressView alloc] init];
        _progressView.bounds = CGRectMake( 0, 0, 60, 60);
        _progressView.center = self.center;
    }
    _progressView.progress = 0.0001;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}

@end
