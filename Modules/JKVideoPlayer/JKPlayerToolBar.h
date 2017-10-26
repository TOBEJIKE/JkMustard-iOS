//
//  JKPlayerToolBar.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPlayerToolBar;
@protocol JKPlayerToolBarDelegate <NSObject>
@optional
- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar didClickScreenButton:(BOOL)isLandscape; // isLandscape:是否是切换到全屏状态
- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderDidTouchDown:(UISlider *)slider; // slider按下状态
- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderValueChanged:(CGFloat)value; // slider值发生改变
- (void)JKPlayerToolBar:(JKPlayerToolBar *)toolBar sliderValueDidEndChanged:(CGFloat)value; // slider值改变结束


@end

@interface JKPlayerToolBar : UIView
@property (nonatomic, weak) id<JKPlayerToolBarDelegate> jkDelegate; // 代理

@property (nonatomic, assign) double currentPlayProgress; // 当前的播放进度
@property (nonatomic, assign) double totalPlayProgress; // 总的播放时长

@property (nonatomic, assign) double currentBufferProgress; // 当前的缓冲进度
@property (nonatomic, assign) BOOL clearBufferProgress; // 清除缓冲进度
@property (nonatomic, assign) BOOL clickScreenButton; // 外层控制点击内部的切换全屏按钮
@end
