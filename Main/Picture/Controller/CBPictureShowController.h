//
//  CBPictureShowController.h
//  mustard
//
//  Created by chinabyte on 2017/8/18.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBBaseViewController.h"
#import "JKPhoto.h"
#import "SDWebImageManager+JKExtension.h"
#import "UIImageView+JKExtension.h"

@interface CBPictureShowController : CBBaseViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *photos;// 所有的图片对象
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@end
