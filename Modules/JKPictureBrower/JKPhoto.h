//
//  JKPhoto.h
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKPhoto : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片
@property (nonatomic, strong) NSString *photoDescription; // 描述
@property (nonatomic, strong) UIImageView *srcImageView; // 来源view

@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;
@property (nonatomic, assign) BOOL firstShow;
@property (nonatomic, assign) int index; // 索引
@end
