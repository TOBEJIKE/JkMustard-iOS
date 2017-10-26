//
//  CBSetPwViewController.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBBaseViewController.h"

@interface CBSetPwViewController : CBBaseViewController
@property (nonatomic,assign)int type;
@property (nonatomic,copy)NSString * phoneNum;
@property (nonatomic,copy)NSString * codeStr;
@end
