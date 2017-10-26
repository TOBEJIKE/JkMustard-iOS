//
//  JKNewsChannelView.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKNewsChannelView;

@protocol JKNewsChannelViewDelegate <NSObject>
@optional
- (void)JKNewsChannelsView:(JKNewsChannelView *)newsChannelsView didSelectedNewsChannelItemAtIndex:(NSInteger)index; // 选中某一个频新闻道
- (void)JKNewsChannelsView:(JKNewsChannelView *)newsChannelsView didSelectedAddNewsChannelButton:(BOOL)selected; // 添加新闻频道的加号按钮

@end

@interface JKNewsChannelView : UIView
@property (nonatomic, retain) NSArray *newsChannels; // 频道数组
@property (nonatomic,assign) NSInteger currentIndex;// 选中分类，默认为0
@property (nonatomic, weak) id<JKNewsChannelViewDelegate> jkDelegate; // 代理
@property (nonatomic, assign) BOOL hideAddButton;// 隐藏加号按钮

+ (instancetype)newsChannelsView;
// 根据索引滚动到中间位置
- (void)scrollerToCenterWithIndex:(NSInteger)index;
// 根据索引切换频道的状态
- (void)transformStatusWithCurrentIndex:(NSInteger)currentIndex nextIndex:(NSInteger)nextIndex withRate:(CGFloat)rate;
// 选中某一个频道
- (void)selectNewsChannelsItemWithIndex:(NSInteger)index; // 选中某一个频新闻道
@end
