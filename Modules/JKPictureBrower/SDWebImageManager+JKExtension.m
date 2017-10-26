//
//  SDWebImageManager+JKExtension.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "SDWebImageManager+JKExtension.h"

@implementation SDWebImageManager (JKExtension)
+ (void)downloadWithURL:(NSURL *)url{
    // cmp不能为空
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}
@end
