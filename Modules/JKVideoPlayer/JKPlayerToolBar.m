//
//  JKPlayerToolBar.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKPlayerToolBar.h"
#import "UIView+JKExtension.h"
#import "NSString+JKExtension.h"

@interface JKPlayerToolBar ()
@property (nonatomic, weak) UILabel *currentTimeLabel; // 当前时间
@property (nonatomic, weak) UILabel *totalTimeLabel; // 总时间
@property (nonatomic, weak) UIButton *screenButton; // 切换全屏按钮
@property (nonatomic, weak) UIProgressView *progressView; // 进度条
@property (nonatomic, weak) UISlider *slider; // 滑块
@end

@implementation JKPlayerToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    
    // 当前时间
    UILabel *currentTimeLabel = [UILabel new];
    currentTimeLabel.textColor = [UIColor redColor];
    [currentTimeLabel sizeToFit];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    //    currentTimeLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:currentTimeLabel];
    self.currentTimeLabel = currentTimeLabel;
    
    // 总时间
    UILabel *totalTimeLabel = [UILabel new];
    totalTimeLabel.textColor = [UIColor redColor];
    [totalTimeLabel sizeToFit];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    //    totalTimeLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:totalTimeLabel];
    self.totalTimeLabel = totalTimeLabel;
    
    // 切换全屏按钮
    UIButton *screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    screenButton.backgroundColor = [UIColor yellowColor];
    //    [screenButton setTitle:@"全屏" forState:UIControlStateNormal];
    //    [screenButton setTitle:@"小屏" forState:UIControlStateSelected];
    [screenButton setImage:[UIImage imageNamed:@"video_landscape"] forState:UIControlStateNormal];
    [screenButton setImage:[UIImage imageNamed:@"video_portrait"] forState:UIControlStateSelected];
    [screenButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [screenButton addTarget:self action:@selector(screenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:screenButton];
    self.screenButton = screenButton;
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor whiteColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    // 滑块
    UISlider *slider = [UISlider new];
    slider.maximumTrackTintColor = [UIColor clearColor];
    slider.minimumValue = 0.0;
    slider.minimumTrackTintColor = [UIColor redColor];
    //    slider.thumbTintColor = [UIColor brownColor];
    [slider setThumbImage:[UIImage imageNamed:@"video_slider_thum"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged]; // 拖动
    [slider addTarget:self action:@selector(sliderDidTouchDown:) forControlEvents:UIControlEventTouchDown]; // 拖动
    [slider addTarget:self action:@selector(sliderValueDidEndChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel]; // 点击
    [self addSubview:slider];
    self.slider = slider;
    
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.jk_width;
    CGFloat height = self.jk_height;
    CGFloat timeWidth = 60;
    self.currentTimeLabel.frame = CGRectMake(0, 0, timeWidth, height);
    self.screenButton.frame = CGRectMake(width - height, 0, height, height);
    self.totalTimeLabel.frame = CGRectMake(width - timeWidth - height - 10, 0, timeWidth, height);
    self.progressView.jk_width = CGRectGetMinX(self.totalTimeLabel.frame) - CGRectGetMaxX(self.currentTimeLabel.frame) - 20;
    self.progressView.jk_centerY = height * 0.5;
    self.progressView.jk_x = timeWidth + 10;
    
    self.slider.jk_width = self.progressView.jk_width;
    self.slider.jk_x = self.progressView.jk_x-2;
    
    self.slider.jk_centerY = height * 0.5;
    
}

#pragma mark - 全屏按钮点击
- (void)screenButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if ([self.jkDelegate respondsToSelector:@selector(JKPlayerToolBar:didClickScreenButton:)]) {
        [self.jkDelegate JKPlayerToolBar:self didClickScreenButton:sender.selected];
    }
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchOrientationNotification" object:@(sender.selected)];
    
}

// 按下滑块
- (void)sliderDidTouchDown:(UISlider *)slider{
    
    if ([self.jkDelegate respondsToSelector:@selector(JKPlayerToolBar:sliderDidTouchDown:)]) {
        [self.jkDelegate JKPlayerToolBar:self sliderDidTouchDown:slider];
    }
}

// 拖动滑块
- (void)sliderValueChanged:(UISlider *)slider{
    
    if ([self.jkDelegate respondsToSelector:@selector(JKPlayerToolBar:sliderValueChanged:)]) {
        [self.jkDelegate JKPlayerToolBar:self sliderValueChanged:slider.value];
    }
}

// 抬起手指
- (void)sliderValueDidEndChanged:(UISlider *)slider{
    
    if ([self.jkDelegate respondsToSelector:@selector(JKPlayerToolBar:sliderValueDidEndChanged:)]) {
        [self.jkDelegate JKPlayerToolBar:self sliderValueDidEndChanged:slider.value];
    }
    
}

- (void)setCurrentPlayProgress:(double)currentPlayProgress{
    _currentPlayProgress = currentPlayProgress;
    
    [self.slider setValue:currentPlayProgress animated:YES];
    self.currentTimeLabel.text = [NSString playerTimeStringWithProgress:currentPlayProgress];
    
}

- (void)setTotalPlayProgress:(double)totalPlayProgress{
    _totalPlayProgress = totalPlayProgress;
    
    self.slider.maximumValue = totalPlayProgress;
    self.totalTimeLabel.text = [NSString playerTimeStringWithProgress:totalPlayProgress];
}

- (void)setCurrentBufferProgress:(double)currentBufferProgress{
    _currentBufferProgress = currentBufferProgress;
    
    [self.progressView setProgress:currentBufferProgress animated:YES];
}

- (void)setClearBufferProgress:(BOOL)clearBufferProgress{
    _clearBufferProgress = clearBufferProgress;
    if (clearBufferProgress) {
        
        [self.progressView setProgress:0 animated:NO];
    }
}

- (void)setClickScreenButton:(BOOL)clickScreenButton{
    _clickScreenButton = clickScreenButton;
    if (clickScreenButton) {
        [self screenButtonClick:self.screenButton];
    }
}


@end
