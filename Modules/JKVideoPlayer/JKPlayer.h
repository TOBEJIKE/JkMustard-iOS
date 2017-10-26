//
//  JKPlayer.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>
// 播放器的播放状态
typedef NS_ENUM(NSInteger, JKPlayerStatus) {
    JKPlayerStatusPlaying, // 正在播放中
    JKPlayerStatusPause, // 暂停
    JKPlayerStatusReadyToPlay, // 准备好播放
    JKPlayerStatusReadyingToPlay, // 准备中
};

// 滑动手势的状态
typedef NS_ENUM(NSInteger, JKSlidingStatus) {
    JKSlidingStatusVoice, // 调节音量
    JKSlidingStatusBrightness, // 调节亮度
    JKSlidingStatusForward, // 快进
    JKSlidingStatusNone, // 没有滑动
};

@class JKPlayer;
@protocol JKPlayerDelegate <NSObject>
@optional
// 视频旋转,外层控制器控制状态栏显示与隐藏
- (void)JKPlayer:(JKPlayer *)player didOrientation:(BOOL)isLandscape; // isLandscape:是否是切换到全屏状态
@end


@interface JKPlayer : UIView
@property (nonatomic, weak) id<JKPlayerDelegate> jkDelegate; // 代理
@property (nonatomic, strong) NSURL *videoUrl; // 视频路径URL
@property (nonatomic, assign) JKPlayerStatus status; // 播放状态
@property (nonatomic, assign) BOOL hideBrightnessVolumeForwardView; // 是否隐藏自定义的亮度view,声音view,快进快退view
@property (nonatomic, strong) UIView *playerSuperView; // 自定义播放器的父视图
// 播放
- (void)play;
//  暂停
- (void)pause;

// 播放器展示
- (void)playerDidAppear;
// 播放器消失
- (void)playerDidDisappear;

// 移除通知
- (void)removeNotification;
@end
