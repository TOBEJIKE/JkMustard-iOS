//
//  JKNewsChannelController.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKNewsChannelController;
@protocol JKNewsChannelControllerDelegate <NSObject>
@optional
// 选中我的频道中的item
- (void)JKNewsChannelController:(JKNewsChannelController *)controlelr didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
// 我的频道中的items交换位置
- (void)JKNewsChannelController:(JKNewsChannelController *)controlelr moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
// 添加频道推荐中的item
- (void)JKNewsChannelController:(JKNewsChannelController *)controlelr didAddItemAtIndexPath:(NSIndexPath *)indexPath;
// 删除我的频道中的item
- (void)JKNewsChannelController:(JKNewsChannelController *)controlelr didDeleteItemAtIndexPath:(NSIndexPath *)indexPath;
// 删除我的频道中的item
- (void)JKNewsChannelController:(JKNewsChannelController *)controller didDeleteItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
@end

@interface JKNewsChannelController : UIViewController
@property (nonatomic, weak) id<JKNewsChannelControllerDelegate> jkDelegate;
@property (nonatomic, retain) NSArray * dataSource;
@property (nonatomic, assign) NSInteger currentIndex;
@end
