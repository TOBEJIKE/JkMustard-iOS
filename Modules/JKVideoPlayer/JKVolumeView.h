//
//  JKVolumeView.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKVolumeView : UIView
+ (instancetype)shareInstance;
@property (nonatomic, assign) CGFloat volumeValue; // 声音的value值
@end
