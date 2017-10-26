//
//  JKPlayer.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+JKExtension.h"
#import "JKPlayerToolBar.h"
#import "JKBrightnessView.h"
#import "JKVolumeView.h"
#import "JKVolumeSlider.h"
#import "JKRetreatForwardView.h"
#import "NSString+JKExtension.h"

static NSString *JKVideosPlayerItemStatus = @"status";
static NSString *JKVideosPlayerItemLoadedTimeRanges = @"loadedTimeRanges";
const CGFloat interval = 2.0; // 时间间隔

@interface JKPlayer ()<JKPlayerToolBarDelegate>
@property (nonatomic, weak) UIButton *backButton; // 横屏时的返回按钮
@property (nonatomic, weak) UIButton *playButton; // 播放按钮
@property (nonatomic, weak) UIButton *replayButton; //重播按钮
@property (nonatomic, weak) JKPlayerToolBar *toolBar; // 底部的工具条
@property (nonatomic, weak) JKRetreatForwardView *retreatForwardView; // 快进，快退View
@property (nonatomic, weak) UIView *touchView; // 亮度，声音控制View
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView; // 加载指示器
@property (nonatomic, strong) AVPlayer *player; // 播放器
@property (nonatomic, strong) AVPlayerItem *playerItem; // 播放器item（存储视频信息，缓冲进度等）
@property (nonatomic, strong) AVPlayerLayer *playerLayer; // 播放器图层
@property (nonatomic, strong) id playTimeObserver; // 视频进度观察者
@property (nonatomic, assign) BOOL isPlayingInPast; // 标记从后台进入到前台之前是否正在播放中
@property (nonatomic, assign) BOOL isAppearByWindow; // 标记播放器是否在当前window窗口中显示
@property (nonatomic, assign) BOOL isPlayFinished; // 播放完成标记
@property (nonatomic, assign) BOOL isLandscape; // 标记是否是横屏

// 亮度，声音，快进相关
@property (nonatomic, assign) CGPoint beginMovePoint; // 开始拖动的点
@property (nonatomic, assign) JKSlidingStatus slidingStatus; // 滑动的状态
@property (nonatomic, assign) BOOL sliding; // 正在拖动中
@property (nonatomic, assign) CGFloat beginMoveVoiceValue; // 开始拖动时的音量
@property (nonatomic, assign) NSTimeInterval videoTotalProgress; // 总时长
@property (nonatomic, assign) NSTimeInterval videoCurrentProgress; // 当前的播放进度
@property (nonatomic, assign) CGRect originFrame; // 原始的相对window的frame
@property (nonatomic, assign) BOOL autoPlay; // 自动播放
@end

@implementation JKPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubViews];
        [self addNotifications]; // 添加通知
        
    }
    return self;
}

#define mark - 添加子 view
- (void)addSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.autoPlay = YES; // 控制播放器加载完成的时候自动播放视频
    
    [self addSubview:[JKVolumeSlider shareInstance]];
    
    CGFloat width = self.jk_width;
    CGFloat height = self.jk_height;
    
    self.player = [AVPlayer new];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // 将播放器图层添加到副图层上
    [self.layer addSublayer:self.playerLayer];
    
    UIView *touchView = [UIView new];
    touchView.backgroundColor = [UIColor clearColor];
    touchView.alpha = 0.5;
    [self addSubview:touchView];
    self.touchView = touchView;
    
    // 单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewTapGestureAction)];
    [touchView addGestureRecognizer:tapGesture];
    // 拖动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewPanGestureAction:)];
    [touchView addGestureRecognizer:panGesture];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.hidden = YES;
    backButton.alpha = 0.0;
    //    [backButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    //    backButton.backgroundColor = [UIColor redColor];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.backButton = backButton;
    
    
    // 播放按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    //    [playButton setTitle:@"暂停" forState:UIControlStateSelected];
    [playButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateSelected];
    playButton.frame = CGRectMake(0, 0, 40, 40);
    playButton.hidden = YES;
    playButton.alpha = 0.0;
    //    [playButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    //    playButton.backgroundColor = [UIColor redColor];
    [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    // 重播按钮
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [replayButton setTitle:@"重播" forState:UIControlStateNormal];
    [replayButton setImage:[UIImage imageNamed:@"video_replay"] forState:UIControlStateNormal];
    replayButton.frame = CGRectMake(0, 0, 40, 40);
    //    [replayButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    //    replayButton.backgroundColor = [UIColor redColor];
    [replayButton addTarget:self action:@selector(replayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    replayButton.hidden = YES;
    [self addSubview:replayButton];
    self.replayButton = replayButton;
    
    
    // 底部的工具条
    JKPlayerToolBar *toolBar = [JKPlayerToolBar new];
    toolBar.jkDelegate = self;
    toolBar.hidden = YES;
    toolBar.alpha = 0.0;
    CGFloat toolBarHeight = 40;
    toolBar.frame = CGRectMake(0, height - toolBarHeight, width, toolBarHeight);
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 刷新指示器
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 更新音量view的初始值
    [JKVolumeView shareInstance].volumeValue = [JKVolumeSlider shareInstance].value;
    
    JKRetreatForwardView *retreatForwardView = [JKRetreatForwardView new];
    retreatForwardView.jk_width = 150;
    retreatForwardView.jk_height = 100;
    retreatForwardView.hidden = YES;
    [self addSubview:retreatForwardView];
    self.retreatForwardView = retreatForwardView;
    
    
    
}

#pragma mark - 布局子 view
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.touchView.frame = self.bounds;
    self.playButton.jk_centerX = self.jk_width * 0.5;
    self.playButton.jk_centerY = self.jk_height * 0.5;
    self.playerLayer.frame = self.bounds;
    
    self.indicatorView.jk_centerX = self.jk_width * 0.5;
    self.indicatorView.jk_centerY = self.jk_height * 0.5;
    
    self.replayButton.jk_centerX = self.jk_width * 0.5;
    self.replayButton.jk_centerY = self.jk_height * 0.5;
    
    self.toolBar.jk_y = self.jk_height - self.toolBar.jk_height;
    self.toolBar.jk_width = self.jk_width;
    
    self.retreatForwardView.jk_centerX = self.jk_width * 0.5;
    self.retreatForwardView.jk_centerY = self.jk_height * 0.5;
    
}

#pragma mark - 注册观察者，添加通知
- (void)addNotifications{
    
    
    __weak typeof(self) weakSelf = self;
    // 注册播放进度观察者, 每秒执行30次， CMTime 为30分之一秒（回调函数美妙执行30次）
    self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        // 当前播放秒(当前播放进度)->self.playerItem.currentTime.value(当前帧数) ／ self.playerItem.currentTime.timescale（每秒的帧数）
        //        double currentPlayTime = (double)weakSelf.playerItemx.currentTime.value / weakSelf.playerItem.currentTime.timescale;
        double currentPlayTime = (double)time.value / time.timescale;
        
        // 更新进度条
        weakSelf.toolBar.currentPlayProgress = currentPlayTime;
        weakSelf.retreatForwardView.currentPlayProgress = currentPlayTime;
        weakSelf.videoCurrentProgress = currentPlayTime;
        if (weakSelf.videoCurrentProgress > weakSelf.videoTotalProgress) {
            weakSelf.videoCurrentProgress = weakSelf.videoTotalProgress;
        }
        
    }];
    
    // 注册通知
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 程序进入后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark - 移除通知
- (void)removeNotification{
    [self.playerItem removeObserver:self forKeyPath:JKVideosPlayerItemStatus];
    [self.playerItem removeObserver:self forKeyPath:JKVideosPlayerItemLoadedTimeRanges];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeTimeObserver:self.playTimeObserver];
    self.playTimeObserver = nil;
    self.player = nil;
    self.playerItem = nil;
}

- (void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
    if ([AVAudioSession sharedInstance].otherAudioPlaying) {
        NSLog(@"系统正在播放其他音乐");
    } else {
        NSLog(@"系统没有播放其他音乐");
    }
    self.status = JKPlayerStatusReadyingToPlay; // 准备中
    
    [self.indicatorView startAnimating];
    
    if (self.autoPlay) {
        self.isPlayingInPast = YES;
    }
    self.isAppearByWindow = YES;
    
    // 初始化播放器item
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    // 初始化播放器
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    
    // 注册观察者(视频的状态，缓冲情况)
    [self.playerItem addObserver:self forKeyPath:JKVideosPlayerItemStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:JKVideosPlayerItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object; // 播放器item
    // 播放状态
    if ([keyPath isEqualToString:JKVideosPlayerItemStatus]) {
        
        // 获取playerItem的状态
        AVPlayerItemStatus status = playerItem.status;//[[change objectForKey:@"new"] intValue];
        
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            self.status = JKPlayerStatusReadyToPlay; // 准备好
            
            // 获取视频时间总长度
            CMTime duration = playerItem.duration;
            double totalSeconds = CMTimeGetSeconds(duration);  // 总共有多少秒 相当于 duration.value / duration.timeScale
            
            self.videoTotalProgress = totalSeconds;
            self.toolBar.totalPlayProgress = totalSeconds;
            self.retreatForwardView.totalPlayProgress = totalSeconds;
            
            [self.indicatorView stopAnimating];
            
            // 播放器准备好播放有多种情况出发，所以需要判断
            if (self.isAppearByWindow) {
                
                if (self.isPlayingInPast) {
                    
                    // 播放
                    [self play];
                }
            }
            
            
        } else if (status == AVPlayerStatusFailed) { // 一定要打开网络权限
            
            NSLog(@"AVPlayerStatusFailed=%@",playerItem.error.description);
            
            [self.indicatorView stopAnimating];
            
        } else {
            
            NSLog(@"AVPlayerStatusUnknown");
            [self.indicatorView stopAnimating];
        }
        
    } else if ([keyPath isEqualToString:JKVideosPlayerItemLoadedTimeRanges]) { // 缓冲进度
        
        NSLog(@"正在缓冲");
        
        NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges]; // 获取item的缓冲数组(Returns an NSArray of NSValues containing CMTimeRanges)
        
        // CMTimeRange 结构体 start:起始位置 duration:持续时间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds; // 计算总缓冲时间 = start + duration
        
        CGFloat totalDuration = CMTimeGetSeconds(self.playerItem.duration); // 总时间
        
        self.toolBar.currentBufferProgress = timeInterval / totalDuration;
    }
    
}

#pragma mark - 视频播放完成
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    self.isPlayFinished = YES;
    
    self.playButton.hidden = YES;
    self.playButton.selected = NO;
    self.replayButton.hidden = NO;
    [self hideSubViews];
}

#pragma mark - 程序进入前台
- (void)applicationWillEnterForeground{
    
    NSLog(@"applicationWillEnterForeground");
    if (self.isPlayFinished) { // 处于播放完成的状态，直接返回
        return;
    }
    
    if (self.isAppearByWindow == NO) {
        return;
    }
    if (self.isPlayingInPast) { // 如果之前处于播放播放的状态，则继续播放
        
        [self play];
    }
    
}
#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground{
    NSLog(@"applicationDidEnterBackground");
    if (self.isPlayFinished) { // 处于播放完成的状态，直接返回
        return;
    }
    
    
    [self pause];
    
}
#pragma mark - 程序即将失去焦点
- (void)applicationWillResignActive{
    
    NSLog(@"applicationWillResignActive");
}
#pragma mark - 程序获取焦点
- (void)applicationDidBecomeActive{
    
    NSLog(@"applicationDidBecomeActive");
}

#pragma mark - 重播按钮点击事件
- (void)replayButtonClick:(UIButton *)sender{
    
    sender.hidden = YES;
    self.playButton.hidden = NO;
    self.isPlayFinished = NO;
    
    [self.playerItem seekToTime:kCMTimeZero]; // 跳转到初始
    self.toolBar.currentPlayProgress = 0; // 设置进度条的当前进度为0
    self.toolBar.clearBufferProgress = YES;
    [self play];
}
#pragma mark - 播放按钮点击事件
- (void)playButtonClick:(UIButton *)sender{
    
    if (!sender.selected) {
        
        [self play];
    } else {
        [self pause];
        self.isPlayingInPast = NO;
    }
}

#pragma mark - 返回按钮点击事件
- (void)backButtonClick:(UIButton *)sender{
    self.toolBar.clickScreenButton = YES;
}

#pragma mark - 开始播放
- (void)play{
    self.status = JKPlayerStatusPlaying;
    self.isPlayingInPast = YES;
    self.playButton.selected = YES;
    [self.player play];
    if (!self.toolBar.hidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideSubViews];
        });
    }
}

#pragma mark - 暂停播放
- (void)pause{
    self.status = JKPlayerStatusPause;
    self.playButton.selected = NO;
    [self.player pause];
}

#pragma mark -  播放器展示
- (void)playerDidAppear{
    self.isAppearByWindow = YES;
    if (self.isPlayFinished) {
        return;
    }
    if (self.isPlayingInPast) {
        [self play];
    }
}

#pragma mark -  播放器消失
- (void)playerDidDisappear{
    self.isAppearByWindow = NO;
    if (self.status == JKPlayerStatusPlaying) {
        [self pause];
    }
}


#pragma mark - dealloc销毁
- (void)dealloc{
    NSLog(@"播放器被销毁了dealloc");
    [[JKVolumeView shareInstance] removeFromSuperview];
    [[JKBrightnessView shareInstance] removeFromSuperview];
    [self removeNotification];
}

#pragma mark - TTPlayerToolBarDelegate
- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderValueChanged:(CGFloat)value{
    CMTime changedTime = CMTimeMakeWithSeconds(value, 1.0);
    [self.playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
        
    }];
}

- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderValueDidEndChanged:(CGFloat)value{
    if (self.isPlayingInPast) {
        [self play];
    }
}

- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderDidTouchDown:(UISlider *)slider{
    [self pause];
}

- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar didClickScreenButton:(BOOL)isLandscape{
    self.isLandscape = isLandscape;
    if (isLandscape) {
        self.backButton.hidden = NO;
        if (self.backButton.alpha == 0.0) {
            self.backButton.alpha = 1.0;
        }
    } else {
        self.backButton.hidden = YES;
    }
    if (isLandscape) {
        CGRect frame = [self.playerSuperView.window convertRect:self.playerSuperView.frame fromView:self.playerSuperView.superview];
        self.originFrame = frame;
        [self switchOrientation:UIInterfaceOrientationLandscapeRight];
    } else {
        [self switchOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)switchOrientation:(UIInterfaceOrientation)orientation{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight: // 横屏
        {
            [self removeFromSuperview];
            [self.playerSuperView.window addSubview:self];
            
            self.jk_width = [UIScreen mainScreen].bounds.size.height;
            self.jk_height = [UIScreen mainScreen].bounds.size.width;
            self.jk_center = self.window.center;
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.5 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
                [JKBrightnessView shareInstance].transform = CGAffineTransformMakeRotation(M_PI_2);
                [JKVolumeView shareInstance].transform = CGAffineTransformMakeRotation(M_PI_2);
            } completion:^(BOOL finished) {
                // 隐藏状态栏
                if ([self.jkDelegate respondsToSelector:@selector(JKPlayer:didOrientation:)]) {
                    [self.jkDelegate JKPlayer:self didOrientation:YES];
                }
            }];
            
        }
            break;
        case UIInterfaceOrientationPortrait: // 竖屏
        {
            // 显示状态栏
            if ([self.jkDelegate respondsToSelector:@selector(JKPlayer:didOrientation:)]) {
                [self.jkDelegate JKPlayer:self didOrientation:NO];
            }
            
            // 需要把动画放在变换frame之前，否则会引起界面布局混乱
            [UIView animateWithDuration:0.5 animations:^{
                self.transform = CGAffineTransformIdentity;
                [JKBrightnessView shareInstance].transform = CGAffineTransformIdentity;
                [JKVolumeView shareInstance].transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self.playerSuperView addSubview:self];
                self.frame = self.playerSuperView.bounds;
                
            }];
            
            //            self.frame = self.playerSuperView.frame;
            self.frame = self.originFrame;
            [self layoutIfNeeded];
            
            
        }
            break;
            
        default:
            break;
    }
    
}


/*
 #pragma mark - 旋转控制器
 - (void)TTPlayerToolBar:(TTPlayerToolBar *)toolBar didClickScreenButton:(BOOL)isLandscape{
 
 
 self.isLandscape = isLandscape;
 
 if (isLandscape) {
 self.backButton.hidden = NO;
 if (self.backButton.alpha == 0.0) {
 self.backButton.alpha = 1.0;
 }
 } else {
 
 self.backButton.hidden = YES;
 }
 
 //    if (isLandscape) {
 //        [self forceOrientation:UIInterfaceOrientationLandscapeRight];
 //    } else {
 //
 //        [self forceOrientation:UIInterfaceOrientationPortrait];
 //    }
 
 //    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
 //        [self forceOrientation:UIInterfaceOrientationLandscapeRight];
 //    } else {
 //
 //        [self forceOrientation:UIInterfaceOrientationPortrait];
 //    }
 }
 
 #pragma mark - 强制横屏
 - (void)forceOrientation:(UIInterfaceOrientation)orientation{
 // setOrientation: 私有方法强制横屏
 if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
 SEL selector = NSSelectorFromString(@"setOrientation:");
 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
 
 [invocation setSelector:selector];
 [invocation setTarget:[UIDevice currentDevice]];
 int val = orientation;
 [invocation setArgument:&val atIndex:2];
 [invocation invoke];
 }
 }
 
 #pragma mark - 系统监测屏幕的旋转
 - (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
 
 CGRect bounds = [UIScreen mainScreen].bounds;
 
 [super traitCollectionDidChange:previousTraitCollection];
 
 if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
 
 self.tt_width = bounds.size.width;
 self.tt_height = bounds.size.width/16*9;
 
 } else {
 
 self.tt_width = bounds.size.width;
 self.tt_height = bounds.size.height;
 
 }
 }
 */
#pragma mark - 单击View隐藏，显示toolbar
- (void)touchViewTapGestureAction{
    if (self.isPlayFinished) { // 播放完成之后，不允许点击显示子view
        return;
    }
    if (self.toolBar.hidden) { // 显示toolbar
        [self showSubViews];
    } else { // 隐藏toolbar
        [self hideSubViews];
    }
}

#pragma mark - // 显示toolbar
- (void)showSubViews{
    self.toolBar.hidden = NO;
    self.playButton.hidden = NO;
    if (self.isLandscape) {
        self.backButton.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.toolBar.alpha = 1.0;
        self.playButton.alpha = 1.0;
        if (self.isLandscape) {
            self.backButton.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        self.toolBar.hidden = NO;
        self.playButton.hidden = NO;
        
        if (self.isLandscape) {
            self.backButton.hidden = NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.status != JKPlayerStatusPause) {
                [self hideSubViews];
            }
        });
        
        
    }];
    
}

#pragma mark - 隐藏toolbar
- (void)hideSubViews{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isLandscape) {
            self.backButton.alpha = 0.0;
        }
        self.toolBar.alpha = 0.0;
        self.playButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        self.toolBar.hidden = YES;
        self.playButton.hidden = YES;
        
        if (self.isLandscape) {
            self.backButton.hidden = YES;
        }
    }];
}

#pragma mark - 屏幕亮度，声音大小控制
- (void)touchViewPanGestureAction:(UIPanGestureRecognizer *)panGesture{
    //    if (self.hideBrightnessVolumeForwardView) { // 隐藏声音，亮度，快进快退view
    //        return;
    //    }
    if (!self.isLandscape) { // 竖屏不允许操作
        return;
    }
    CGPoint point = [panGesture locationInView:panGesture.view];
    UIGestureRecognizerState state = panGesture.state;
    if (state == UIGestureRecognizerStateBegan) { // 开始拖动
        NSLog(@"拖动开始");
        [self.window addSubview:[JKBrightnessView shareInstance]];
        [self.window addSubview:[JKVolumeView shareInstance]];
        self.beginMovePoint = point;
        self.sliding = NO;
        self.beginMoveVoiceValue = [JKVolumeSlider shareInstance].value;
    } else if (state == UIGestureRecognizerStateChanged) { // 拖动中
        // 如果拖动的范围<10，不做任何操作
        if (fabs(point.x - self.beginMovePoint.x) < 10 && fabs(point.y - self.beginMovePoint.y) < 10) {
            return;
        }
        if (!self.sliding) {
            // 倾斜度
            float gradient = fabs(point.y - self.beginMovePoint.y) / fabs(point.x - self.beginMovePoint.x);
            if (gradient < 1 / sqrt(3)) { // 滑动的角度小于等于30度（倾斜度小于等于30度）为快进
                self.slidingStatus = JKSlidingStatusForward;
                self.retreatForwardView.hidden = NO;
                if (!self.toolBar.hidden) {
                    [self hideSubViews];
                }
            } else if (gradient >= sqrt(3)) {
                if (self.beginMovePoint.x < self.jk_width * 0.5) { // 亮度
                    self.slidingStatus = JKSlidingStatusBrightness;
                } else { // 声音
                    self.slidingStatus = JKSlidingStatusVoice;
                }
            } else {
                self.slidingStatus = JKSlidingStatusNone;
            }
            self.sliding = YES;
        }
        if (self.slidingStatus == JKSlidingStatusForward) { // 调节进度
            NSTimeInterval videoCurrentTime = [self getPointCurrentProgress:point];
            if (videoCurrentTime > self.videoCurrentProgress) {
                self.retreatForwardView.imageName = @"video_progress_right";
            } else if(videoCurrentTime < self.videoCurrentProgress) {
                self.retreatForwardView.imageName = @"video_progress_left";
            }
            NSString *currentString = [NSString playerTimeStringWithProgress:videoCurrentTime];
            NSString *totalString = [NSString playerTimeStringWithProgress:self.videoTotalProgress];
            
            self.retreatForwardView.text = [NSString stringWithFormat:@"%@ / %@", currentString,totalString];
            
        } else if (self.slidingStatus == JKSlidingStatusBrightness) { // 调节亮度
            [UIScreen mainScreen].brightness -= ((point.y - self.beginMovePoint.y) / 5000);
            
        } else if (self.slidingStatus == JKSlidingStatusVoice) { // 调节音量
            
            float voiceValue = self.beginMoveVoiceValue - ((point.y - self.beginMovePoint.y) / self.touchView.jk_height);
            
            if (voiceValue < 0) {
                
                [JKVolumeSlider shareInstance].value = 0;
                [JKVolumeView shareInstance].volumeValue = 0;
                
            } else if (voiceValue > 1) {
                
                [JKVolumeSlider shareInstance].value = 1;
                [JKVolumeView shareInstance].volumeValue = 1;
                
            } else {
                
                [JKVolumeSlider shareInstance].value = voiceValue;
                [JKVolumeView shareInstance].volumeValue = voiceValue;
            }
            
        }
        
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) { // 拖动结束或者拖动取消
        NSLog(@"拖动结束");
        self.sliding = NO;
        if (self.slidingStatus == JKSlidingStatusForward) { // 调节进度
            self.retreatForwardView.hidden = YES;
            NSTimeInterval videoCurrentTime = [self getPointCurrentProgress:point];

            CMTime changedTime = CMTimeMakeWithSeconds(videoCurrentTime, 1.0);
            [self.playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
                
            }];
        }
    }
    
}

#pragma mark - 获取当前point点的进度
- (NSTimeInterval)getPointCurrentProgress:(CGPoint)point{
    float videoCurrentTime = self.videoCurrentProgress + 99 * ((point.x - self.beginMovePoint.x) / self.jk_width);
    
    if (videoCurrentTime > self.videoTotalProgress) {
        videoCurrentTime = self.videoTotalProgress;
    }
    if (videoCurrentTime < 0) {
        videoCurrentTime = 0;
    }
    
    return videoCurrentTime;
}


@end
