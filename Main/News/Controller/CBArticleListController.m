//
//  CBArticleListController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBArticleListController.h"
#import "CBNewsModel.h"
#import "CBImagesCell.h"
#import "CBArticleDetailController.h"

@interface CBArticleListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation CBArticleListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    self.dataSource = [[NSMutableArray alloc]init];
    [self loadData];
}
- (void)loadData{
    NSString * articleStr = @"http://219.239.88.28/index.php/api/collection/get_public_articles";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"categoryid"] = self.articleID;
    parameter[@"start"] = @"0";
    parameter[@"direction"] = @"1";
    [CBHTTPSessionManager post:articleStr params:parameter success:^(id data) {
        if ([data[@"code"] isEqualToNumber:@1000]) {
            NSArray * arrayM = [CBNewsModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"articles"]];
            for (CBNewsModel * model in arrayM) {
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"数据异常");
        }
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBNewsModel * model = self.dataSource[indexPath.row];
    CGFloat rowHeight = [CBImagesCell heightForRow:model];
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBNewsModel * model = self.dataSource[indexPath.row];
    NSString * ID = [CBImagesCell idForRow:model];
    if ([ID isEqualToString:@"ImagesCell"]) {
        CBImagesCell *cell = [CBImagesCell cellWithTableView:tableView];
        cell.countL.textColor = [UIColor blackColor];
        [cell.deleteB addTarget:self action:@selector(getPotision:) forControlEvents:UIControlEventTouchUpInside];
        cell.dataModel = model;
        return cell;
    }else{
        CBImagesCell *cell = [CBImagesCell cellWithTableView:tableView];
        cell.countL.textColor = [UIColor blackColor];
        cell.dataModel = model;
        return cell;
    }
}
- (void)getPotision:(UIButton *)sender{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBNewsModel * model = self.dataSource[indexPath.row];
    NSString * ID = [CBImagesCell idForRow:model];
    if ([ID isEqualToString:@"ImagesCell"]) {
        CBArticleDetailController * detail = [[CBArticleDetailController alloc]init];
        detail.model = model;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
