//
//  JKRetreatForwardView.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKRetreatForwardView : UIView
@property (nonatomic, assign) double currentPlayProgress; // 当前的播放进度
@property (nonatomic, assign) double totalPlayProgress; // 总的播放时长
@property (nonatomic, copy) NSString *imageName; // 图片名称
@property (nonatomic, copy) NSString *text; // 文本
@end
