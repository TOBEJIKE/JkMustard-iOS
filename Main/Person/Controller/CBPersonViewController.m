//
//  CBPersonViewController.m
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBPersonViewController.h"
#import "CBLoginViewController.h"

@interface CBPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * headerImageview;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (strong, nonatomic) CBHelperUI * helper;
@property (nonatomic,strong) UILabel * nameLabel;
@end

@implementation CBPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helper = [[CBHelperUI alloc]init];
    [self creatUI];
}
- (void)creatUI{
    self.headerImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
    [self.headerImageview setImage:[UIImage imageNamed:@"me_header"]];
    self.headerImageview.userInteractionEnabled = YES;
    [self.view addSubview:self.headerImageview];
    //
    [self.helper addImageViewWithFrame:CGRectMake(ScreenWidth-40, 30, 25, 25) withImageName:@"me_header_msg" target:self Event:@selector(msgBtnClick) inView:self.headerImageview];
    [self.helper addImageViewWithFrame:CGRectMake(ScreenWidth-75, 30, 25, 25) withImageName:@"me_header_set" target:self Event:@selector(setBtnClick) inView:self.headerImageview];
    //
    [self.helper addImageViewWithFrame:CGRectMake(ScreenWidth/2-30, 65, 60, 60) withImageName:@"me_header_icon" target:self Event:@selector(pushLogin) inView:self.headerImageview];
    //
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-50, 130, 100, 30)];
    self.nameLabel.text = @"尚未登陆";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = 1;
    [self.view addSubview:self.nameLabel];
    
    [self.helper addImageViewWithFrame:CGRectMake(ScreenWidth/2-85, 160, 20, 20) andImageName:@"me_integral" inView:self.headerImageview];
    [self.helper addLabelWithFrame:CGRectMake(ScreenWidth/2-60, 160, 50, 20) andText:@"积分：60" textColor:[UIColor whiteColor] fontSize:10 alignment:0 inView:self.headerImageview];
    [self.helper addImageViewWithFrame:CGRectMake(ScreenWidth/2+50, 160, 20, 20) andImageName:@"me_sign_in" inView:self.headerImageview];
    [self.helper addLabelWithFrame:CGRectMake(ScreenWidth/2+75, 160, 50, 20) andText:@"签到" textColor:[UIColor whiteColor] fontSize:10 alignment:0 inView:self.headerImageview];
    //
    NSArray * btnArr = @[@"me_collect",@"me_money"];
    NSArray * labelArr = @[@"收藏夹",@"钱包"];
    for (int i = 0; i < 2; i ++) {
        CBDIYButton *btn = [[CBDIYButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-100+140*i,220, 60, 50)];
        [btn setTitle:labelArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:GrayColor forState:UIControlStateNormal];
        btn.tag = i+1;
        [btn setImage:[UIImage imageNamed:btnArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnArr[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(collectOrPay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    //
    [self creatTableview];
}
- (void)collectOrPay:(UIButton *)sender{
    NSInteger i = sender.tag;
    switch (i) {
        case 1:
        {
            NSLog(@"收藏夹");
        }
            break;
            
        case 2:
        {
            NSLog(@"钱包");
        }
            break;
            
        default:
            break;
    }
}
- (void)creatTableview{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 270, ScreenWidth, ScreenHeight-300) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = GrayColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.dataSource = @[@[@"消息",@"任务中心"],@[@"浏览记录",@"离线下载",@"我的关注"],@[@"设置",@"意见反馈"]];
}
#pragma mark 各种点击事件
- (void)setBtnClick{
    NSLog(@"设置");
}
- (void)msgBtnClick{
    NSLog(@"信息");
}
- (void)login:(UIButton *)btn{
    NSInteger i = btn.tag;
    switch (i) {
        case 1:
            NSLog(@"手机登陆");
            break;
        case 2:
            NSLog(@"QQ登陆");
            break;
        case 3:
            NSLog(@"微信登陆");
            break;
        default:
            break;
    }
}
- (void)pushLogin{
    NSLog(@"登陆");
    CBLoginViewController * login = [[CBLoginViewController alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
}
- (void)btnClick:(UIButton *)btn{
    NSInteger i = btn.tag;
    switch (i) {
        case 1:
            NSLog(@"收藏夹");
            break;
        case 2:
            NSLog(@"钱包");
            break;
        default:
            break;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

#pragma mark UITableViewDelegate / UItableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * headerViewId = @"headerViewId";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerViewId];
    }
    headerView.backgroundColor = GrayColor;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * string = @"meCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.separatorInset = UIEdgeInsetsMake(20, 0, ScreenWidth-40, 1);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"消息");
        }else{
            NSLog(@"任务中心");
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NSLog(@"浏览记录");
        }else if (indexPath.row == 1){
            NSLog(@"离线下载");
        }else{
            NSLog(@"我的关注");
        }
    }else{
        if (indexPath.row == 0) {
            NSLog(@"设置");
        }else{
            NSLog(@"意见反馈");
        }
    }
}

@end
