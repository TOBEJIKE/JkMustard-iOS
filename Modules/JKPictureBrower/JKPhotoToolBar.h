//
//  JKPhotoToolBar.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPhotoToolBar;
@protocol JKPhotoToolBarDelegate <NSObject>
- (void)didClickReplyBtn:(JKPhotoToolBar *)photoToolBar;
@end

@interface JKPhotoToolBar : UIView
@property (nonatomic,weak)id<JKPhotoToolBarDelegate>jkDelegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@end
