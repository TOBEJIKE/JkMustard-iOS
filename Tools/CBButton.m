//
//  CBButton.m
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBButton.h"

@implementation CBButton

- (void)setHighlighted:(BOOL)highlighted{
    
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

@end
