//
//  MBProgressHUD+JKExtension.m
//  mustard
//
//  Created by chinabyte on 2017/8/21.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "MBProgressHUD+JKExtension.h"

@implementation MBProgressHUD (JKExtension)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"failInfo" view:view];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self show:success icon:@"successInfo" view:view];
}

#pragma mark 显示一些信息

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    // YES代表需要蒙版效果
//        hud.dimBackground = NO;
    return hud;
}
@end
