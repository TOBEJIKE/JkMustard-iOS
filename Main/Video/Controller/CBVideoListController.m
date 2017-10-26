//
//  CBVideoListController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBVideoListController.h"
#import "CBVideoModel.h"
#import "CBVideoCell.h"
#import "CBVideoModelFrame.h"
#import "CBVideoDetailController.h"
#import "JKPlayer.h"

@interface CBVideoListController ()<UITableViewDelegate,UITableViewDataSource,CBVideoCellDelegate,JKPlayerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)JKPlayer * player;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, assign) BOOL isLandscape; // 横屏
@end

@implementation CBVideoListController

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
    NSString * videoStr = @"http://219.239.88.28/index.php/api/collection/get_public_videos";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
//    parameter[@"categoryid"] = self.videoID;
    parameter[@"categoryid"] = @"39";
    parameter[@"start"] = @"0";
    parameter[@"direction"] = @"1";
    [CBHTTPSessionManager post:videoStr params:parameter success:^(id data) {
        if ([data[@"code"] isEqualToNumber:@1000]) {
            NSArray * arrayM = [CBVideoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"videos"]];
            NSMutableArray *statusFrameArray = [NSMutableArray array];
            for (CBVideoModel * model in arrayM) {
                CBVideoModelFrame * videoModelFrame = [[CBVideoModelFrame alloc]init];
                videoModelFrame.videodata = model;
                [statusFrameArray addObject:videoModelFrame];
            }
            self.dataSource = statusFrameArray;
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
    CBVideoModelFrame * videoFrame = self.dataSource[indexPath.row];
    return videoFrame.cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBVideoCell *cell = [CBVideoCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.ttDelegate = self;
    cell.videodataframe = self.dataSource[indexPath.row];
    return cell;
}
- (void)CBVideosCell:(CBVideoCell *)cell didClickPlayButton:(BOOL)play{
    if(play){
        NSLog(@"123");
        [self addPlayViewToTableViewWithCell:cell];
    }
}
- (void)addPlayViewToTableViewWithCell:(CBVideoCell *)cell{
    [self destroyCBPlayer];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CBVideoModelFrame *videoFrame = self.dataSource[indexPath.row];
    CGFloat playerY = videoFrame.cellH * indexPath.row;
    
    self.baseView = [UIView new];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.frame = CGRectMake(0, playerY, ScreenWidth, ScreenWidth/16*9);
    
    self.player = [[JKPlayer alloc] initWithFrame:self.baseView.bounds];
    self.player.playerSuperView = self.baseView;
    self.player.videoUrl = [NSURL URLWithString:videoFrame.videodata.video_url];
    self.player.hideBrightnessVolumeForwardView = YES;
    self.player.jkDelegate = self;
    [self.baseView addSubview:self.player];
    [self.tableView addSubview:self.baseView];
}
- (void)destroyCBPlayer{
    if (self.player) {
        [self.player removeNotification];
        [self.player removeFromSuperview];
        self.player = nil;
    }
    if (self.baseView) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
}
// 状态栏的显示方式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
// 在屏幕旋转为横屏的时候，默认会隐藏状态栏，所以需要实现这个方法并返回NO，保持状态了一直处于显示状态
- (BOOL)prefersStatusBarHidden{
    return self.isLandscape;
}
- (void)JKPlayer:(JKPlayer *)player didOrientation:(BOOL)isLandscape{
    self.isLandscape = isLandscape;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.player) {
        [self.player playerDidAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.player) {
        [self.player playerDidDisappear];
    }
}

- (void)dealloc{
    [self destroyCBPlayer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.player) {
        CGRect frame = [self.view.window convertRect:self.baseView.frame fromView:self.tableView];
        if (CGRectContainsRect(self.view.window.frame, frame)) { // 包含关系
            NSLog(@"包含关系");
        } else { // 交集与没有交集
            CGRect rect = CGRectIntersection(self.view.window.frame, frame);
            //            NSLog(@"frame==%@,",NSStringFromCGRect(rect));
            if (rect.size.height > 0) { // 有交集
                NSLog(@"交集");
            } else {
                NSLog(@"其他");
                if (self.player) {
                    [self.player removeNotification];
                    [self.player removeFromSuperview];
                    self.player = nil;
                }
                if (self.baseView) {
                    [self.baseView removeFromSuperview];
                    self.baseView = nil;
                }
            }
        }
    }

}
@end
