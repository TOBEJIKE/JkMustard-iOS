//
//  UIImage+CBExtension.h
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CBExtension)
// 根据颜色生成图片
+ (instancetype)imageWithColor:(UIColor *)color;
// instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类的对象
// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;
// 加载渲染图片
+ (instancetype)imageWithStretchableName:(NSString *)imageName;
//返回圆形图片
- (instancetype)circleImage;

+ (instancetype)circleImage:(NSString *)name;
@end
