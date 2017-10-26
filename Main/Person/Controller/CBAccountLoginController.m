//
//  CBAccountLoginController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBAccountLoginController.h"
#import "CBRegisterOrFindController.h"

@interface CBAccountLoginController ()
@property (nonatomic,strong) UITextField * textField1;
@property (nonatomic,strong) UITextField * textField2;
@property (nonatomic,strong)CBHelperUI * helpUI;
@end

@implementation CBAccountLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpUI = [[CBHelperUI alloc]init];
    [self creatUI];
}
#pragma mark 创建UI
- (void)creatUI{
    [self.helpUI addBtnWithFrame:CGRectMake(24, 30, 32, 32) andImage:@"me_close" cornerRadius:15 target:self withEvent:@selector(closeClick) inView:self.view];
    [self.helpUI addImageViewWithFrame:CGRectMake(ScreenWidth/2-50, 90, 100, 100) andImageName:@"me_icon" cornerRadius:40 inView:self.view];
    NSArray * fieldArr = @[@"请输入账号",@"请输入密码"];
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
        [self.helpUI addBtnWithframe:CGRectMake(ScreenWidth-80, 275+45*i, 20, 20) withtag:i+1 andImage:@"me_close" cornerRadius:10 target:self withEvent:@selector(deleteBtn:) inView:self.view];
        if (i == 1) {
            [self.helpUI addBtnWithFrame:CGRectMake(ScreenWidth-160, 270 +45, 80, 30) andTitle:@"找回密码" fontSize:14 titleColor:MainThemeColor target:self withEvent:@selector(findPw) inView:self.view];
        }
    }
    [self.helpUI addBtnWithFrame:CGRectMake(75, 370, ScreenWidth-150, 60) andTitle:@"登陆" backColor:MainThemeColor cornerRadius:5 fontSize:15 titleColor:[UIColor whiteColor] target:self withEvent:@selector(loginClick) inView:self.view];
    
    [self.helpUI addBtnWithFrame:CGRectMake(ScreenWidth/2-60, 450, 120, 20) andTitle:@"快速免密登陆" fontSize:15 titleColor:GrayColor target:self withEvent:@selector(NoPWLogin) inView:self.view];
    
    [self.helpUI addBtnWithFrame:CGRectMake(ScreenWidth/2-60, 500, 120, 20) andTitle:@"新用户注册" fontSize:15 titleColor:MainThemeColor target:self withEvent:@selector(Register) inView:self.view];
    
    NSArray * loginArr = @[@"me_login_qq",@"me_login_wx",@"me_login_wb"];
    for (int i = 0; i < 3; i ++) {
        [self.helpUI addImageViewWithFrame:CGRectMake(ScreenWidth/2-125+100*i, ScreenHeight-100, 50, 50) andImageName:loginArr[i] inView:self.view];
    }
}
#pragma mark 触发事件
- (void)loginClick{
    NSLog(@"账号登陆");
    NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/mobile_login";
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc]init];
    parameter[@"mobile"] = @"";
    parameter[@"password"] = @"";
    [CBHTTPSessionManager post:urlStr params:parameter success:^(id data) {
        NSLog(@"");
    } fail:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)NoPWLogin{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Register{
    NSLog(@"开始注册");
    CBRegisterOrFindController * findOrRegister = [[CBRegisterOrFindController alloc]init];
    findOrRegister.type = 1;
    [self.navigationController pushViewController:findOrRegister animated:YES];
}
- (void)findPw{
    NSLog(@"找回密码");
    CBRegisterOrFindController * findOrRegister = [[CBRegisterOrFindController alloc]init];
    findOrRegister.type = 2;
    [self.navigationController pushViewController:findOrRegister animated:YES];
}
- (void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteBtn:(UIButton *)btn{
    
}

@end
