//
//  CBPictureListController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBPictureListController.h"
#import "CBPictureModel.h"
#import "CBPictureCell.h"
#import "CBAlbumFrame.h"
#import "CBPictureShowController.h"
#import "CBPictureShowController.h"
#import "JKPhoto.h"

@interface CBPictureListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation CBPictureListController

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
    NSString * videoStr = @"http://219.239.88.28/index.php/api/collection/get_public_album";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
//    parameter[@"categoryid"] = self.pictureID;
    parameter[@"categoryid"] = @"27";
    parameter[@"start"] = @"0";
    parameter[@"direction"] = @"1";
    [CBHTTPSessionManager post:videoStr params:parameter success:^(id data) {
        if ([data[@"code"] isEqualToNumber:@1000]) {
            NSArray * arrayM = [CBPictureModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"pics"]];
            NSMutableArray *statusFrameArray = [NSMutableArray array];
            for (CBPictureModel * model in arrayM) {
                CBAlbumFrame * albumFrame = [[CBAlbumFrame alloc]init];
                albumFrame.pictureModel = model;
                [statusFrameArray addObject:albumFrame];
            }
            self.dataSource = statusFrameArray;
            [self.tableView reloadData];
        }else{
            NSLog(@"数据异常");
        }
    } fail:^(NSError *error) {
        NSLog(@"");
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBAlbumFrame * videoFrame = self.dataSource[indexPath.row];
    return videoFrame.cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPictureCell *cell = [CBPictureCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.albumFrame = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBAlbumFrame * albumFrame = self.dataSource[indexPath.row];
    CBPictureModel * picModel = albumFrame.pictureModel;
    NSMutableArray * photos = [[NSMutableArray alloc]init];
    for (int i = 0; i < picModel.img_list.count; i ++) {
        JKPhoto * photo = [[JKPhoto alloc]init];
        photo.url = picModel.img_list[i][@"url"];
        photo.photoDescription = picModel.img_list[i][@"description"];
        [photos addObject:photo];
    }
    CBPictureShowController * photoBrowser = [[CBPictureShowController alloc]init];
    photoBrowser.hidesBottomBarWhenPushed = YES;
    photoBrowser.photos = photos;
    photoBrowser.currentPhotoIndex = 0;
    [self.navigationController pushViewController:photoBrowser animated:YES];
}
@end
