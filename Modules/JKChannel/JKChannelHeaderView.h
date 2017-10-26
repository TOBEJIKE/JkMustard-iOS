//
//  JKChannelHeaderView.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKChannelHeaderView,JKNewsChannelEdit;
@protocol  JKChannelHeaderViewDelegate<NSObject>
// isEditing：编辑按钮是否处于编辑状态
- (void)JKChannelHeaderView:(JKChannelHeaderView *)headerView didClickEditButton:(BOOL)isEditing;

@end

@interface JKChannelHeaderView : UICollectionReusableView
@property (nonatomic, copy) JKNewsChannelEdit * channelEdit; // 频道的编辑模型
@property (nonatomic, weak) id<JKChannelHeaderViewDelegate> jkDelegate;
@end
