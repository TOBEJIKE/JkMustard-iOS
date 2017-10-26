//
//  CBLoginViewController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBLoginViewController.h"
#import "CountDownButton.h"
#import "CBAccountLoginController.h"

@interface CBLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITextField * textField1;
@property (nonatomic,strong) UITextField * textField2;
@property(nonatomic,strong) CountDownButton * countDownButton;
@property (nonatomic,strong)CBHelperUI * helpUI;
@property (nonatomic,strong)NSString * msgCode;
@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpUI = [[CBHelperUI alloc]init];
    [self creatUI];
}
#pragma mark 搭建UI
- (void)creatUI{
    [self.helpUI addBtnWithFrame:CGRectMake(24, 30, 32, 32) andImage:@"me_close" cornerRadius:15 target:self withEvent:@selector(closeClick) inView:self.view];
    [self.helpUI addImageViewWithFrame:CGRectMake(ScreenWidth/2-50, 90, 100, 100) andImageName:@"me_icon" cornerRadius:40 inView:self.view];
    [self creatTextField];
    [self.helpUI addBtnWithFrame:CGRectMake(75, 370, ScreenWidth-150, 60) andTitle:@"免密登陆" backColor:MainThemeColor cornerRadius:5 fontSize:15 titleColor:[UIColor whiteColor] target:self withEvent:@selector(loginClick) inView:self.view];
    [self.helpUI addBtnWithFrame:CGRectMake(ScreenWidth/2-60, 450, 120, 20) andTitle:@"已有账号登陆" fontSize:15 titleColor:MainThemeColor target:self withEvent:@selector(accountLogin) inView:self.view];
    NSArray * loginArr = @[@"me_login_qq",@"me_login_wx",@"me_login_wb"];
    for (int i = 0; i < 3; i ++) {
        [self.helpUI addImageViewWithFrame:CGRectMake(ScreenWidth/2-125+100*i, ScreenHeight-100, 50, 50) withImageName:loginArr[i] tag:i+1 target:self Event:@selector(thirdlogin:) inView:self.view];
    }
    [self.helpUI addLabelWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 30) andText:@"注册或登陆即同意芥末头条用户协议" textColor:GrayColor fontSize:14 alignment:1 inView:self.view];
    
}
#pragma mark 此处代码啰嗦，考虑重构
- (void)creatTextField{
    NSArray * fieldArr = @[@"请输入账号",@"请输入验证码"];
    for (int i = 0; i < 2; i ++) {
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(70, 265+45*i, 150, 40)];
        textField.backgroundColor = [UIColor clearColor];
        UIColor * color = GrayColor;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:fieldArr[i] attributes:@{NSForegroundColorAttributeName:color}];
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:18];
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDefault;
        textField.tag = i+1;
        [self.view addSubview:textField];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 265+40+45*i, ScreenWidth-120, 1)];
        label.backgroundColor = GrayColor;
        [self.view addSubview:label];
        if (i==0) {
            [self.helpUI addBtnWithFrame:CGRectMake(ScreenWidth-80, 270, 20, 20) andImage:@"me_close" cornerRadius:10 target:self withEvent:@selector(deleteBtn) inView:self.view];
        }
        if (i==1) {
            self.countDownButton = [CountDownButton buttonWithType:UIButtonTypeCustom];
            self.countDownButton.frame = CGRectMake(ScreenWidth-92-60, 298+10+5+2, 92, 25);
            self.countDownButton.layer.masksToBounds = YES;
            self.countDownButton.layer.cornerRadius = 5;
            self.countDownButton.layer.borderWidth = 1;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 217/255.0, 217/255.0, 217/255.0, 1 });
            [self.countDownButton.layer setBorderColor:colorref];//边框颜色
            [self.countDownButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
            [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.countDownButton setTitleColor:GrayColor forState:UIControlStateNormal];
            self.countDownButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:self.countDownButton];
        }
    }
}
#pragma mark 触发事件
- (void)getCode{
    NSLog(@"获取验证码");
    UITextField * field1 = (UITextField *)[self.view viewWithTag:1];
    if (![self.helpUI isValidateMobile:field1.text]) {
        [MBProgressHUD showError:@"手机号格式不对"];
    }else{
        NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/mobile_sendSMS";
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        dic[@"mobile"] = field1.text;
        dic[@"purpose"] = @"login";
        [CBHTTPSessionManager post:urlStr params:dic success:^(id data) {
            NSLog(@"获取验证码成功===%@",data);
            if ([data[@"code"]  isEqual: @1000]){
                self.msgCode = data[@"data"][0];
                NSLog(@"验证码===%@",self.msgCode);
                [self.countDownButton countDownButtonHandler:^(CountDownButton*sender, NSInteger tag) {
                    sender.enabled = NO;
                    [sender startCountDownWithSecond:10];
                    [sender countDownChanging:^NSString *(CountDownButton *countDownButton,NSUInteger second) {
                        NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                        return title;
                    }];
                    [sender countDownFinished:^NSString *(CountDownButton *countDownButton, NSUInteger second) {
                        countDownButton.enabled = YES;
                        return @"点击重新获取";
                    }];
                }];
            }else{
                [MBProgressHUD showError:@"请求失败"];
            }
        } fail:^(NSError *error) {
            NSLog(@"失败");
        }];
    }
}
- (void)loginClick{
    NSLog(@"快速登录");
    NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/captcha_login";
    UITextField * field1 = (UITextField *)[self.view viewWithTag:1];
    UITextField * field2 = (UITextField *)[self.view viewWithTag:2];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    dic[@"mobile"] = field1.text;
    dic[@"captcha"] = field2.text;
    [CBHTTPSessionManager post:urlStr params:dic success:^(id data) {
        NSLog(@"快速登录成功%@",data);
    } fail:^(NSError *error) {
        NSLog(@"快速登录失败");
    }];
}
- (void)accountLogin{
    NSLog(@"账号登陆");
    CBAccountLoginController * accountLogin = [[CBAccountLoginController alloc]init];
    [self.navigationController pushViewController:accountLogin animated:YES];
}
- (void)thirdlogin:(id)sender{
    if ([sender view].tag == 1) {
        NSLog(@"QQ登陆");
        [self getAuthWithUserInfoFromQQ];
    }else if ([sender view].tag == 2){
        NSLog(@"微信登陆");
        [self getAuthWithUserInfoFromWX];
    }else{
        NSLog(@"新浪登陆");
        [self getAuthWithUserInfoFromSina];
    }
}
- (void)getAuthWithUserInfoFromQQ{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"QQ失败===%@",error);
        }else{
             UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ unionid: %@", resp.unionId);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (void)getAuthWithUserInfoFromWX{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"WX失败===%@",error);
        }else{
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (void)getAuthWithUserInfoFromSina{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"sina失败===%@",error);
        }else{
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteBtn{
    
}
@end
