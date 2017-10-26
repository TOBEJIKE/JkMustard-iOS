//
//  JKVolumeSlider.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKVolumeSlider.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static JKVolumeSlider * volumeSlider;

@implementation JKVolumeSlider

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //        volumeView.showsRouteButton = NO;
        //        volumeView.showsVolumeSlider = NO;
        //        [volumeView userActivity]; // 显示音量view
        
        for (UIView *view in volumeView.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
                
                volumeSlider = (JKVolumeSlider *)view;
                //                [volumeView setVolumeThumbImage:[UIImage imageNamed:@"slider透明"] forState:UIControlStateNormal];
                [volumeSlider setThumbTintColor:[UIColor clearColor]];
                volumeSlider.minimumTrackTintColor = [UIColor clearColor];
                volumeSlider.maximumTrackTintColor = [UIColor clearColor];
                volumeSlider.frame = CGRectZero;
                break;
            }
        }
    });
    return volumeSlider;
}
@end
