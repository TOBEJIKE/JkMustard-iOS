//
//  CBVideoModelFrame.h
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBVideoModel;
@interface CBVideoModelFrame : NSObject

@property (nonatomic , strong) CBVideoModel * videodata;
//题目
@property (nonatomic , assign) CGRect titleF;
//播放图标
@property (nonatomic , assign) CGRect playF;
//图片
@property (nonatomic , assign) CGRect coverF;
//时长
@property (nonatomic , assign) CGRect lengthF;
//播放来源图片
@property (nonatomic , assign) CGRect playImageF;
//播放来源文字
@property (nonatomic , assign) CGRect playCountF;
//时间
@property (nonatomic , assign) CGRect ptimeF;
//分割线
@property (nonatomic , assign) CGRect lineVF;
//cell的高度
@property (nonatomic , assign) CGFloat cellH;
@end
