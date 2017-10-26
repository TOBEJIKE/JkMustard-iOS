//
//  UIColor+CBExtension.h
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CBExtension)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
