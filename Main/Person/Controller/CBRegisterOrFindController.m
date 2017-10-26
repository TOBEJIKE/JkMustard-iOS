//
//  CBRegisterOrFindController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBRegisterOrFindController.h"
#import "CountDownButton.h"
#import "CBSetPwViewController.h"
@interface CBRegisterOrFindController ()
@property (nonatomic,strong) UITextField * textField1;
@property (nonatomic,strong) UITextField * textField2;
@property (nonatomic,strong) CountDownButton * countDownButton;
@property (nonatomic,strong)CBHelperUI * helpUI;
@property (nonatomic,strong) NSString * msgCode;
@end

@implementation CBRegisterOrFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpUI = [[CBHelperUI alloc]init];
    [self creatUI];
}

#pragma mark 搭建UI
- (void)creatUI{
    [self.helpUI addBtnWithFrame:CGRectMake(24, 30, 32, 32) andImage:@"me_close" cornerRadius:15 target:self withEvent:@selector(closeClick) inView:self.view];
    if (self.type == 1) {
        [self.helpUI addLabelWithFrame:CGRectMake(ScreenWidth/2-75, 120, 150, 50) andText:@"新用户注册" textColor:MainThemeColor fontSize:20 alignment:1 inView:self.view];
    }else if (self.type == 2){
        [self.helpUI addLabelWithFrame:CGRectMake(ScreenWidth/2-75, 120, 150, 50) andText:@"找回密码" textColor:MainThemeColor fontSize:20 alignment:1 inView:self.view];
    }
    [self.helpUI addBtnWithFrame:CGRectMake(24, 30, 32, 32) andImage:@"me_close" cornerRadius:15 target:self withEvent:@selector(closeClick) inView:self.view];
    [self creatTextField];
    [self.helpUI addBtnWithFrame:CGRectMake(75, 370, ScreenWidth-150, 60) andTitle:@"下一步" backColor:MainThemeColor cornerRadius:5 fontSize:15 titleColor:[UIColor whiteColor] target:self withEvent:@selector(nextClick) inView:self.view];
}
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
        textField.tag = i+3;
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
    }
}
- (void)deleteBtn{
    NSLog(@"删除");
    UITextField * field1 = (UITextField *)[self.view viewWithTag:3];
    field1.text = @"";
}
- (void)getCode{
    UITextField * field1 = (UITextField *)[self.view viewWithTag:3];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    dic[@"phoneNum"] = field1.text;
    if (self.type == 1) {
        dic[@"type"] = @"register";
    }else{
        dic[@"type"] = @"findpw";
    }
    if (![self.helpUI isValidateMobile:field1.text]) {
        [MBProgressHUD showError:@"手机号格式不对"];
    }else{
        NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/mobile_sendSMS";
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
#pragma mark 点击事件
- (void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextClick{
    UITextField * field1 = (UITextField *)[self.view viewWithTag:1];
    UITextField * field2 = (UITextField *)[self.view viewWithTag:2];
    NSString * urlStr = @"http://219.239.88.28/index.php/api/customer/check_SMS";
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc]init];
    parameter[@"mobile"] = field1.text;
    parameter[@"code"] = field2.text;
    if (self.type == 1) {
        parameter[@"purpose"] = @"register";
    }else{
        parameter[@"purpose"] = @"findpw";
    }
    [CBHTTPSessionManager post:urlStr params:parameter success:^(id data) {
        if ([data[@"code"]  isEqual: @1000]) {
            NSLog(@"验证码通过");
            CBSetPwViewController * setPw = [[CBSetPwViewController alloc]init];
            setPw.phoneNum = field1.text;
            setPw.type = self.type;
            setPw.codeStr = self.msgCode;
            [self.navigationController pushViewController:setPw animated:YES];
        }else{
            NSLog(@"验证码未通过");
        }
    } fail:^(NSError *error) {
        NSLog(@"");
    }];

}
- (void)deleteBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
