//
//  CBHelperUI.h
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBHelperUI : NSObject
//label
- (UILabel *)addLabelWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor inView:(UIView*)superView;
- (UILabel *)addLabelWithFrame:(CGRect)frame andText:(NSString*)text textColor:(UIColor*)color
                      fontSize:(int)size alignment:(NSTextAlignment)alignment bgColor:(UIColor*)bgColor cornerRadius:(int)num inView:(UIView*)superView;
- (UILabel*)addLabelWithFrame:(CGRect)frame andText:(NSString*)text textColor:(UIColor*)color
                     fontSize:(int)size alignment:(NSTextAlignment)alignment inView:(UIView*)superView;
//button
- (UIButton *)addBtnWithFrame:(CGRect)frame andImage:(NSString *)imageName cornerRadius:(int)num target:(id)target withEvent:(SEL)event inView:(UIView *)superView;
- (UIButton *)addBtnWithframe:(CGRect)frame withtag:(int)tag andImage:(NSString *)imageName cornerRadius:(int)num target:(id)target withEvent:(SEL)event inView:(UIView *)superView;

- (UIButton*)addBtnWithFrame:(CGRect)frame andTitle:(NSString*)title fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event inView:(UIView*)superView;
- (UIButton*)addBtnWithFrame:(CGRect)frame andTitle:(NSString*)title backColor:(UIColor*)backColor cornerRadius:(int)cornerRadius fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event inView:(UIView*)superView;
- (UIButton*)addBtnWithFrame:(CGRect)frame andTitle:(NSString*)title backColor:(UIColor*)backColor cornerRadius:(int)cornerRadius fontSize:(CGFloat)size titleColor:(UIColor*)color BorderWidth:(int)borderWidth BorderColor:(UIColor *)borderColor target:(id)target withEvent:(SEL)event inView:(UIView*)superView;
- (UIButton*)addBtnWithFrame:(CGRect)frame andNormalImage:(NSString*)normal highlight:(NSString*)highlight target:(id)target withEvent:(SEL)event inView:(UIView*)superView;
- (UIButton*)addCustomBordBtnWithFrame:(CGRect)frame andTitle:(NSString*)title fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event borderColor:(UIColor*)bdColor inView:(UIView*)superView;
//imageView
- (UIImageView*)addImageViewWithFrame:(CGRect)frame andImageName:(NSString*)imageName inView:(UIView*)superView;
- (UIImageView*)addImageViewWithFrame:(CGRect)frame andImageName:(NSString*)imageName cornerRadius:(int)num inView:(UIView*)superView;

- (UIImageView*)addImageViewWithFrame:(CGRect)frame
                        withImageName:(NSString*)imageName target:(id)target withEvent:(SEL)event inView:(UIView*)superView;
- (UIImageView*)addImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName target:(id)target Event:(SEL)event inView:(UIView*)superView;
- (UIImageView*)addImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName tag:(int)num target:(id)target Event:(SEL)event inView:(UIView*)superView;
//判断手机号
-(BOOL) isValidateMobile:(NSString *)mobile;
//判断密码 正则匹配用户密码6-18位数字和字母组合
-(BOOL)checkPassword:(NSString *) password;
@end
