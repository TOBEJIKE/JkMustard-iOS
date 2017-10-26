//
//  JKNewsChannelCell.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKNewsChannelCell,JKNewsChannel;
@protocol JKNewsChannelCellDelegate <NSObject>
- (void)JKNewsChannelCell:(JKNewsChannelCell *)cell didClickDeleteBtn:(BOOL)isDelete;
@end

@interface JKNewsChannelCell : UICollectionViewCell
@property (nonatomic, retain) JKNewsChannel * channel; // 频道信息
@property (nonatomic, weak) id<JKNewsChannelCellDelegate> jkDelegate;
@end
