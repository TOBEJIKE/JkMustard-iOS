//
//  CBLabel.m
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBLabel.h"

@implementation CBLabel

- (void)setText:(NSString *)text{
    [super setText:text];
    [self sizeToFit];
}

@end
