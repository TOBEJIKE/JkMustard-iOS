//
//  JKTextFieldBtn.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKTextFieldBtn.h"

@implementation JKTextFieldBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x  = 10;
    imageFrame.origin.y = 5;
    imageFrame.size.width = 20;
    imageFrame.size.height = height-10;
    self.imageView.frame = imageFrame;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = 40;
    titleFrame.origin.y = 10;
    titleFrame.size.width = width-50;
    titleFrame.size.height = height-20;
    self.titleLabel.frame = titleFrame;
}

@end
