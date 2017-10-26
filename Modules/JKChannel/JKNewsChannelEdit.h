//
//  JKNewsChannelEdit.h
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKNewsChannelEdit : NSObject
@property (nonatomic, copy) NSString * channalTitle; // 频道标题
@property (nonatomic, copy) NSString * promptTitle; // 频道提示标题
@property (nonatomic, copy) NSString * promptEditTitle; // 频道提示标题（编辑状态下的）
@property (nonatomic, assign) BOOL hideEditView; // 隐藏编辑按钮
@property (nonatomic, assign) BOOL isEditing; // 编辑按钮是否正在处于编辑状态
@end
