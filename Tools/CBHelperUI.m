//
//  CBHelperUI.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBHelperUI.h"

@interface CBHelperUI ()<UIGestureRecognizerDelegate>

@end

@implementation CBHelperUI
//label
- (UILabel *)addLabelWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor inView:(UIView*)superView{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = bgColor;
    [superView addSubview:label];
    return label;
}
- (UILabel *)addLabelWithFrame:(CGRect)frame andText:(NSString*)text textColor:(UIColor*)color
                      fontSize:(int)size alignment:(NSTextAlignment)alignment bgColor:(UIColor*)bgColor cornerRadius:(int)num inView:(UIView*)superView{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text  = text;
    label.textColor = color;
    label.font = SystemFont(size);
    label.textAlignment = alignment;
    label.backgroundColor = bgColor;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = num;
    [superView addSubview:label];
    return label;
}
-(UILabel*)addLabelWithFrame:(CGRect)frame andText:(NSString*)text textColor:(UIColor*)color
                    fontSize:(int)size alignment:(NSTextAlignment)alignment inView:(UIView*)superView{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.userInteractionEnabled = YES;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.textColor = color;
    label.font = SystemFont(size);
    label.text = text;
    [superView addSubview:label];
    return label;
}
//button
- (UIButton *)addBtnWithFrame:(CGRect)frame andImage:(NSString *)imageName cornerRadius:(int)num target:(id)target withEvent:(SEL)event inView:(UIView *)superView{
    UIButton * button = [[UIButton alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    AddBtnEvent(button, target, event);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = num;
    [superView addSubview:button];
    return button;
}
- (UIButton *)addBtnWithframe:(CGRect)frame withtag:(int)tag andImage:(NSString *)imageName cornerRadius:(int)num target:(id)target withEvent:(SEL)event inView:(UIView *)superView{
    UIButton * button = [[UIButton alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    AddBtnEvent(button, target, event);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = num;
    button.tag = tag;
    [superView addSubview:button];
    return button;
    
}
- (UIButton*)addBtnWithFrame:(CGRect)frame
                    andTitle:(NSString*)title fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event inView:(UIView*)superView{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(size);
    [button setTitleColor:color forState:UIControlStateNormal];
    AddBtnEvent(button,target, event);
    [superView addSubview:button];
    return button;
}

- (UIButton*)addBtnWithFrame:(CGRect)frame andTitle:(NSString*)title backColor:(UIColor*)backColor cornerRadius:(int)cornerRadius fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event inView:(UIView*)superView{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(size);
    button.backgroundColor = backColor;
    [button setTitleColor:color forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = cornerRadius;
    AddBtnEvent(button,target, event);
    [superView addSubview:button];
    return button;
}

- (UIButton*)addBtnWithFrame:(CGRect)frame andTitle:(NSString*)title backColor:(UIColor*)backColor cornerRadius:(int)cornerRadius fontSize:(CGFloat)size titleColor:(UIColor*)color BorderWidth:(int)borderWidth BorderColor:(UIColor *)borderColor target:(id)target withEvent:(SEL)event inView:(UIView*)superView{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(size);
    button.backgroundColor = backColor;
    [button setTitleColor:color forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = cornerRadius;
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    AddBtnEvent(button,target, event);
    [superView addSubview:button];
    return button;
}

- (UIButton*)addBtnWithFrame:(CGRect)frame
              andNormalImage:(NSString*)normal highlight:(NSString*)highlight target:(id)target withEvent:(SEL)event inView:(UIView*)superView{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    SETBtnImageNormal(button, normal);
    SETBtnImageHighlight(button, highlight);
    AddBtnEvent(button,target, event);
    [superView addSubview:button];
    return button;
}

- (UIButton*)addCustomBordBtnWithFrame:(CGRect)frame
                              andTitle:(NSString*)title fontSize:(CGFloat)size titleColor:(UIColor*)color target:(id)target withEvent:(SEL)event borderColor:(UIColor*)bdColor inView:(UIView*)superView{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(size);
    [button setTitleColor:color forState:UIControlStateNormal];
    AddBtnEvent(button,target, event);
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = bdColor.CGColor;
    button.layer.borderWidth = 1;
    [superView addSubview:button];
    return button;
}
//imageView
- (UIImageView*)addImageViewWithFrame:(CGRect)frame andImageName:(NSString*)imageName inView:(UIView*)superView{
    UIImageView* iconView = [[UIImageView alloc] initWithFrame:frame];
    SETImageForImageView(iconView, imageName);
    [superView addSubview:iconView];
    return iconView;
}
- (UIImageView*)addImageViewWithFrame:(CGRect)frame andImageName:(NSString*)imageName cornerRadius:(int)num inView:(UIView*)superView{
    UIImageView* iconView = [[UIImageView alloc] initWithFrame:frame];
    SETImageForImageView(iconView, imageName);
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = num;
    [superView addSubview:iconView];
    return iconView;
}
- (UIImageView*)addImageViewWithFrame:(CGRect)frame
                        withImageName:(NSString*)imageName target:(id)target withEvent:(SEL)event inView:(UIView*)superView{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    SETImageForImageView(imageView, imageName);
    imageView.userInteractionEnabled = YES;
    UIButton * imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    imageBtn.backgroundColor = [UIColor clearColor];
    AddBtnEvent(imageBtn,target, event);
    [imageView addSubview:imageBtn];
    [superView addSubview:imageView];
    return imageView;
}
- (UIImageView*)addImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName target:(id)target Event:(SEL)event inView:(UIView*)superView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    SETImageForImageView(imageView, imageName);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:target action:event];
    TapGesture.delegate= target;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView addGestureRecognizer:TapGesture];
    [superView addSubview:imageView];
    return imageView;
}


- (UIImageView*)addImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName tag:(int)num target:(id)target Event:(SEL)event inView:(UIView*)superView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    SETImageForImageView(imageView, imageName);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * TapGesture=[[UITapGestureRecognizer alloc]initWithTarget:target action:event];
    TapGesture.numberOfTouchesRequired = 1; //手指数
    TapGesture.numberOfTapsRequired = 1; //tap次数
    TapGesture.delegate= target;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.tag = num;
    [imageView addGestureRecognizer:TapGesture];
    [superView addSubview:imageView];
    return imageView;
}

-(BOOL) isValidateMobile:(NSString *)mobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
-(BOOL)checkPassword:(NSString *) password{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}
@end
