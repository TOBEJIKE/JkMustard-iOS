//
//  UIView+JKExtension.m
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "UIView+JKExtension.h"

@implementation UIView (JKExtension)
- (CGSize)jk_size{
    return self.frame.size;
}
- (void)setJk_size:(CGSize)jk_size{
    CGRect frame = self.frame;
    frame.size = jk_size;
    self.frame = frame;
}
- (CGFloat)jk_width{
    return self.frame.size.width;
}
- (void)setJk_width:(CGFloat)jk_width{
    CGRect frame = self.frame;
    frame.size.width = jk_width;
    self.frame = frame;
}
- (CGFloat)jk_height{
    return  self.frame.size.height;
}
- (void)setJk_height:(CGFloat)jk_height{
    CGRect frame = self.frame;
    frame.size.height = jk_height;
    self.frame = frame;
}
- (CGFloat)jk_x{
    return self.frame.origin.x;
}
- (void)setJk_x:(CGFloat)jk_x{
    CGRect frame = self.frame;
    frame.origin.x = jk_x;
    self.frame = frame;
}
- (CGFloat)jk_y{
    return self.frame.origin.y;
}
- (void)setJk_y:(CGFloat)jk_y{
    CGRect frame = self.frame;
    frame.origin.y = jk_y;
    self.frame = frame;
}
- (CGPoint)jk_center{
    return self.center;
}
- (void)setJk_center:(CGPoint)jk_center{
    self.center = jk_center;
}
- (CGFloat)jk_centerX{
    return self.center.x;
}
- (void)setJk_centerX:(CGFloat)jk_centerX{
    CGPoint center = self.center;
    center.x = jk_centerX;
    self.center = center;
}
- (CGFloat)jk_centerY{
    return self.center.y;
}
- (void)setJk_centerY:(CGFloat)jk_centerY{
    CGPoint center = self.center;
    center.y = jk_centerY;
    self.center = center;
}
- (CGFloat)jk_right{
    return CGRectGetMaxX(self.frame);
}
- (void)setJk_right:(CGFloat)jk_right{
    self.jk_x = jk_right - self.jk_width;
}
- (CGFloat)jk_bottom{
    return CGRectGetMaxY(self.frame);
}
- (void)setJk_bottom:(CGFloat)jk_bottom{
    self.jk_y = jk_bottom - self.jk_height;
}
@end
