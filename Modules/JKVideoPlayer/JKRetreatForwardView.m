//
//  JKRetreatForwardView.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKRetreatForwardView.h"
#import "UIView+JKExtension.h"
#import "NSString+JKExtension.h"

@interface JKRetreatForwardView ()
@property (nonatomic, weak) UILabel *timeLabel; // 当前时间
@property (nonatomic, weak) UIProgressView *progressView; // 进度条
@property (nonatomic, weak) UIImageView *imageView; // 图片
@end

@implementation JKRetreatForwardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews{
    
    self.backgroundColor = [UIColor colorWithRed:229/255.0 green:231/255.0 blue:234/255.0 alpha:1.00f];
    
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
    
    // 当前时间
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = [UIColor redColor];
    [timeLabel sizeToFit];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIImageView *imageView = [UIImageView new];
    imageView.jk_width = 50;
    imageView.jk_height = 50;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor whiteColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    self.totalPlayProgress = 1.0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.jk_width;
    CGFloat height = self.jk_height;
    CGFloat timeLabelH = 30;
    
    CGFloat space = 10;
    
    self.imageView.jk_centerX = width * 0.5;
    self.imageView.jk_y = space;
    
    
    self.timeLabel.frame = CGRectMake(0, self.imageView.jk_bottom, width, timeLabelH);
    
    self.progressView.jk_width = width - 2 * space;
    self.progressView.jk_centerX = width * 0.5;
    self.progressView.jk_y = height - space;
    
}

- (void)setCurrentPlayProgress:(double)currentPlayProgress{
    _currentPlayProgress = currentPlayProgress;
    
    self.progressView.progress = currentPlayProgress / self.totalPlayProgress; //self.totalPlayProgress==0.0做分母的时候有问题
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setText:(NSString *)text{
    _text = text;
    self.timeLabel.text = text;
}

@end
