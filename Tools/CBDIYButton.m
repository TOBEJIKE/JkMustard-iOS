//
//  CBDIYButton.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBDIYButton.h"

@implementation CBDIYButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = 0;
    imageFrame.origin.x  = (width - 20) / 2;
    imageFrame.size.width = 20;
    imageFrame.size.height = 20;
    self.imageView.frame = imageFrame;
    
    titleFrame.size.width = width;
    titleFrame.size.height = height - imageFrame.size.height;
    titleFrame.origin.y = imageFrame.size.height;
    titleFrame.origin.x = 0;
    
    self.titleLabel.frame = titleFrame;
    //    UITabBarController *tab = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    UITabBarItem *itrm =  tab.tabBar.items[0];
    //    itrm.imag
}

@end
