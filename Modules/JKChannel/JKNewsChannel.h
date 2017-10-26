//
//  JKNewsChannel.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKNewsChannel : NSObject
@property (nonatomic, assign) BOOL canShowDeleteView; // 删除按钮是否可以显示,默认为NO，不能显示
@property (nonatomic, assign) BOOL showDeleteView; // 删除按钮显示与隐藏
@property (nonatomic, copy) NSString *text; // 显示的字符串
@property (nonatomic, assign) BOOL isSelected; // 是否是选中状态
@end
