//
//  JKVolumeView.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKVolumeView.h"
#import "UIView+JKExtension.h"

static NSString * JKBrightnessKeyPath = @"brightness";
static JKVolumeView * volumeView;

const CGFloat VolumeViewH = 155;
const CGFloat VolumeViewW = 155;

@interface JKVolumeView ()
@property (nonatomic, strong) NSMutableArray *progressSubViews;
@end

@implementation JKVolumeView

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        volumeView = [[JKVolumeView alloc] initWithFrame:CGRectMake(0, 0, VolumeViewH, VolumeViewW)];
        volumeView.jk_center = [UIApplication sharedApplication].keyWindow.jk_center;
        
    });
    return volumeView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:229/255.0 green:231/255.0 blue:234/255.0 alpha:1.00f];
    
    self.alpha = 0.0;
    
    CGFloat width = self.jk_width;
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:101/255.0 green:103/255.0 blue:106/255.0 alpha:1.00f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"耳机";
    titleLabel.jk_x = 0;
    titleLabel.jk_y = 0;
    titleLabel.jk_width = width;
    titleLabel.jk_height = 30;
    [self addSubview:titleLabel];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_brightness"]];
    imageView.jk_width = 75;
    imageView.jk_height = 75;
    imageView.jk_center = self.jk_center;
    [self addSubview:imageView];
    
    
    
    
    CGFloat progressViewH = 7;
    CGFloat progressViewY = CGRectGetMaxY(imageView.frame) + (self.jk_height - CGRectGetMaxY(imageView.frame) - progressViewH) * 0.5;
    CGFloat leftSpace = 13;
    CGFloat space = 1;
    
    int imageCount = 16; // 图片的个数
    CGFloat progressViewW = width - 2 * leftSpace; // 进度条View的宽度
    CGFloat imageW = (progressViewW - (imageCount + 1) * space) / imageCount; // 单个view的宽度
    
    self.progressSubViews = [NSMutableArray array];
    
    UIView *progressView = [UIView new];
    progressView.frame = CGRectMake(leftSpace, progressViewY, progressViewW, progressViewH);
    progressView.backgroundColor = [UIColor colorWithRed:101/255.0 green:103/255.0 blue:106/255.0 alpha:1.00f];
    [self addSubview:progressView];
    
    for (int i = 0; i < imageCount; i++) {
        
        CGFloat subViewX = (space + imageW) * i + space;
        UIView *subView = [[UIView alloc] init];
        subView.backgroundColor = [UIColor whiteColor];
        
        subView.frame = CGRectMake(subViewX, space, imageW, progressViewH - 2 * space);
        [progressView addSubview:subView];
        
        [self.progressSubViews addObject:subView];
        
    }
    
}

#pragma mark - 更新进度条
- (void)updateProgressView:(CGFloat)brightness{
    
    CGFloat stage = 1 / 16.0;
    NSInteger grade = brightness / stage;
    
    for (int i = 0; i < self.progressSubViews.count; i++) {
        
        UIView *tip = self.progressSubViews[i];
        
        if (i < grade) {
            
            tip.hidden = NO;
        } else {
            
            tip.hidden = YES;
        }
    }
}

- (void)setVolumeValue:(CGFloat)volumeValue{
    _volumeValue = volumeValue;
    
    [self updateProgressView:volumeValue];
    
    if (self.alpha != 0) {
        return;
    }
    
    self.alpha = 1.0;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.alpha != 1.0) {
            return;
        }
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 0;
        }];
        
    });
}

@end
