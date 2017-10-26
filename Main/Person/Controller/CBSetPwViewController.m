//
//  CBSetPwViewController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBSetPwViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface CBSetPwViewController ()
@property (nonatomic,strong)CBHelperUI * helpUI;
@end

@implementation CBSetPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpUI = [[CBHelperUI alloc]init];
    [self creatUI];//创建返回按钮
}

#pragma mark 搭建UI
- (void)creatUI{
    [self.helpUI addBtnWithFrame:CGRectMake(24, 30, 32, 32) andImage:@"me_close" cornerRadius:15 target:self withEvent:@selector(closeClick) inView:self.view];
    [self.helpUI addLabelWithFrame:CGRectMake(ScreenWidth/2-75, 120, 150, 50) andText:@"输入密码" textColor:MainThemeColor fontSize:20 alignment:1 inView:self.view];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(60, 230, ScreenWidth-120, 30)];
    textField.backgroundColor = [UIColor clearColor];
    UIColor * color = GrayColor;
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:color}];
    textField.textColor = [UIColor blackColor];
    textField.tag = 1;
    textField.font = [UIFont systemFontOfSize:18];
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDefault;
    [self.view addSubview:textField];
    //
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 260, ScreenWidth-120, 1)];
    label.backgroundColor = GrayColor;
    [self.view addSubview:label];
    //
    [self.helpUI addBtnWithFrame:CGRectMake(75, 370, ScreenWidth-150, 60) andTitle:@"确定" backColor:MainThemeColor cornerRadius:5 fontSize:15 titleColor:[UIColor whiteColor] target:self withEvent:@selector(changePw) inView:self.view];
}
#pragma mark 触发事件
- (void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changePw{
    UITextField * field1 = (UITextField *)[self.view viewWithTag:1];
    [field1 resignFirstResponder];
    if (![self.helpUI checkPassword:field1.text]) {
        [MBProgressHUD showError:@"请输入6-18位数字加字母组合"];
    }else{
        if (self.type == 1) {
            NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/mobile_register";
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            dic[@"mobile"] = self.phoneNum;
            dic[@"password"] = [self md5:field1.text];
            [CBHTTPSessionManager post:urlStr params:dic success:^(id data) {
                NSLog(@"注册请求成功");
                if ([data[@"code"]  isEqual: @1000]) {
                    NSLog(@"注册成功");
                }
            } fail:^(NSError *error) {
                NSLog(@"注册失败");
            }];
        }else{
            NSLog(@"找回密码数据请求");
        }
    }
}
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}
@end
