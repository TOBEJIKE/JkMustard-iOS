//
//  UIImageView+JKExtension.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "UIImageView+JKExtension.h"

@implementation UIImageView (JKExtension)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder{
    [self sd_setImageWithURL:url placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder{
    [self setImageURL:[NSURL URLWithString:urlStr]
          placeholder:placeholder];
}
@end
