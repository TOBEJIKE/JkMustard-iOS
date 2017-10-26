//
//  CBVideoModel.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBVideoModel.h"

@implementation CBVideoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"descriptionTitle":@"description"};
}
@end
