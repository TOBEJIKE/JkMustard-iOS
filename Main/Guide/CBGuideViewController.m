//
//  CBGuideViewController.m
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBGuideViewController.h"
#import "JKNewsChannelCell.h"
#import "JKNewsChannel.h"
#import "JKNewsChannelEdit.h"
#import "JKChannelHeaderView.h"

@interface CBGuideViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JKChannelHeaderViewDelegate,JKNewsChannelCellDelegate>
@property (nonatomic,strong)UIScrollView * mainScroller;
//频道选择
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isEditing; // 频道是否正在处于编辑状态
@property (nonatomic, strong) NSMutableArray *channelEditArr; // 频道编辑状态数组
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * newsTop;
@property (nonatomic, strong) NSMutableArray * newsBottom;
@property (nonatomic, strong) NSMutableArray * videoTop;
@property (nonatomic, strong) NSMutableArray * videoBottom;
@property (nonatomic, strong) NSMutableArray * pictureTop;
@property (nonatomic, strong) NSMutableArray * pictureBottom;

@end

@implementation CBGuideViewController

- (NSMutableArray *)channelEditArr{
    if (!_channelEditArr) {
        JKNewsChannelEdit *edit0 = [JKNewsChannelEdit new];
        edit0.channalTitle = @"我的频道";
        edit0.promptTitle = @"点击进入频道";
        edit0.promptEditTitle = @"拖拽可以排序";
        edit0.hideEditView = NO;
        edit0.isEditing = NO;
        
        JKNewsChannelEdit *edit1 = [JKNewsChannelEdit new];
        edit1.channalTitle = @"频道推荐";
        edit1.promptTitle = @"点击添加频道";
        edit1.promptEditTitle = @"";
        edit1.hideEditView = YES;
        edit1.isEditing = NO;
        _channelEditArr = [NSMutableArray arrayWithObjects:edit0,edit1, nil];
    }
    return _channelEditArr;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        int count = 4;
        CGFloat height = 40;
        CGFloat width = (CGRectGetWidth(self.view.frame)-(4+1)*10)/count;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(width,height);
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60-100) collectionViewLayout:layout];
        [_collectionView registerClass:[JKNewsChannelCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        //此处给其增加长按手势，用此手势触发cell移动效果
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [_collectionView addGestureRecognizer:longGesture];
        
        [_collectionView registerClass:[JKChannelHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
        
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditing = NO;
    self.newsTop = [[NSMutableArray alloc]init];
    self.newsBottom = [[NSMutableArray alloc]init];
    self.videoTop = [[NSMutableArray alloc]init];
    self.videoBottom = [[NSMutableArray alloc]init];
    self.pictureTop = [[NSMutableArray alloc]init];
    self.pictureBottom = [[NSMutableArray alloc]init];
    [self loadNewsData];
    [self loadVideoData];
    [self loadPictureData];
}
- (void)loadNewsData{
    NSString * channelStr = @"http://219.239.88.28/index.php/api/collection/get_category";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"resource_type"] = @"article";
    [CBHTTPSessionManager post:channelStr params:parameter success:^(id data) {
        for (int i = 0; i < [data[@"data"] count]; i ++) {
            if ([data[@"data"][i][@"show"] isEqualToString:@"1"]) {
                [self.newsTop addObject:data[@"data"][i]];
            }else{
                [self.newsBottom addObject:data[@"data"][i]];
            }
        }
        [self articleUserDefault];
        [self creatUI];
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
}
- (void)loadVideoData{
    NSString * channelStr = @"http://219.239.88.28/index.php/api/collection/get_category";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"resource_type"] = @"video";
    [CBHTTPSessionManager post:channelStr params:parameter success:^(id data) {
        for (int i = 0; i < [data[@"data"] count]; i ++) {
            if ([data[@"data"][i][@"show"] isEqualToString:@"1"]) {
                [self.videoTop addObject:data[@"data"][i]];
            }else{
                [self.videoBottom addObject:data[@"data"][i]];
            }
        }
        [self videoUserDefault];
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
}
- (void)loadPictureData{
    NSString * channelStr = @"http://219.239.88.28/index.php/api/collection/get_category";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"resource_type"] = @"album";
    [CBHTTPSessionManager post:channelStr params:parameter success:^(id data) {
        for (int i = 0; i < [data[@"data"] count]; i ++) {
            if ([data[@"data"][i][@"show"] isEqualToString:@"1"]) {
                [self.pictureTop addObject:data[@"data"][i]];
            }else{
                [self.pictureBottom addObject:data[@"data"][i]];
            }
        }
        [self pictureUserDefault];
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
}
- (void)articleUserDefault{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:self.newsTop options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data1 forKey:@"articleTopArr"];
    NSData *data2 = [NSJSONSerialization dataWithJSONObject:self.newsBottom options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data2 forKey:@"articleBottomArr"];
}
- (void)videoUserDefault{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:self.videoTop options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data1 forKey:@"videoTopArr"];
    NSData *data2 = [NSJSONSerialization dataWithJSONObject:self.videoBottom options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data2 forKey:@"videoBottomArr"];
}
- (void)pictureUserDefault{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:self.pictureTop options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data1 forKey:@"pictureTopArr"];
    NSData *data2 = [NSJSONSerialization dataWithJSONObject:self.pictureBottom options:NSJSONWritingPrettyPrinted error:nil];
    [userDefault setObject:data2 forKey:@"pictureBottomArr"];
}
- (void)creatUI{
    self.dataSource = [[NSMutableArray alloc]init];
    NSMutableArray *section0 = [NSMutableArray array];
    NSArray *titles0 = self.newsTop;
    for (int i = 0; i < titles0.count; i++) {
        JKNewsChannel *channel = [JKNewsChannel new];
        channel.canShowDeleteView = YES;
        channel.showDeleteView = NO;
        channel.text = titles0[i][@"name"];
        [section0 addObject:channel];
    }
    
    NSMutableArray *section1 = [NSMutableArray array];
    NSArray *titles1 = self.newsBottom;
    for (int i = 0; i < titles1.count; i++) {
        JKNewsChannel *channel = [JKNewsChannel new];
        channel.text = titles1[i][@"name"];
        channel.canShowDeleteView = NO;
        channel.showDeleteView = NO;
        [section1 addObject:channel];
    }
    [_dataSource addObject:section0];
    [_dataSource addObject:section1];
    
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight)];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(ScreenWidth*4,ScreenHeight);
        [self.view insertSubview:self.mainScroller atIndex:0];
        NSArray * imageArray = @[@"1",@"2",@"3"];
        for (int i = 0; i < 3; i ++) {
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
            imageview.userInteractionEnabled = YES;
            [imageview setImage:[UIImage imageNamed:imageArray[i]]];
            [self.mainScroller addSubview:imageview];
        }
        UIView * channalView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight)];
        [self.mainScroller addSubview:channalView];
        [channalView addSubview:self.collectionView];
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(50, ScreenHeight-100, ScreenWidth-100, 40)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        [button setTitle:@"选择默认" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(gotoMain) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor redColor];
        [channalView addSubview:button];
        
        UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, ScreenHeight-50, ScreenWidth-100, 40)];
        button1.layer.masksToBounds = YES;
        button1.layer.cornerRadius = 5;
        [button1 setTitle:@"勾选提交" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(gotoMain) forControlEvents:UIControlEventTouchUpInside];
        button1.backgroundColor = [UIColor redColor];
        [channalView addSubview:button1];
    }
    
}
#pragma mark - 长按手势
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            if (indexPath.section == 1) { // 第二个分区(section==1)不允许长按移动
                return;
            }
            
            self.isEditing = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_NewsChannelEditing" object:@(YES)]; // 发通知给所以item，显示删除按钮
            // 用重新赋值的方法更新section
            JKChannelHeaderView *headerView = (JKChannelHeaderView *)[self.collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            JKNewsChannelEdit *edit = self.channelEditArr.firstObject;
            edit.isEditing = YES;
            headerView.channelEdit = edit;
            
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            CGPoint position = [longGesture locationInView:self.collectionView];
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:position];
            break;
        }
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JKNewsChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.jkDelegate = self;
    cell.channel = self.dataSource[indexPath.section][indexPath.item];
    return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    if (indexPath.section == 0 && indexPath.item == 0) { // 推荐item不允许移动
        return NO;
    } else if (indexPath.section ==1) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 禁止某一项item移动位置（抑制item移动）
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath{
    /* 可以指定位置禁止交换 */
    if (proposedIndexPath.item == 0 && proposedIndexPath.section == 0) {
        return originalIndexPath;
    } else {
        return proposedIndexPath;
    }
}
#pragma mark - 交换位置后调用
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    NSMutableArray *sourceArr = self.dataSource[sourceIndexPath.section];
    JKNewsChannel *channal = sourceArr[sourceIndexPath.item];
    [sourceArr removeObject:channal];
    NSMutableArray *destinationArr = self.dataSource[destinationIndexPath.section];
    [destinationArr insertObject:channal atIndex:destinationIndexPath.item];
    
    if (destinationIndexPath.section == 1) {
        channal.canShowDeleteView = NO;
        channal.showDeleteView = NO;
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    if (destinationIndexPath.section == 1) { // 删除item
        NSLog(@"删除===%ldto%ld",(long)sourceIndexPath.item,(long)destinationIndexPath.item);
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data1 = [userDefault objectForKey:@"articleTopArr"];
        NSData * data2 = [userDefault objectForKey:@"articleBottomArr"];
        NSArray *array1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * mutableArray1 = [NSMutableArray arrayWithArray:array1];
        NSMutableArray * mutableArray2 = [NSMutableArray arrayWithArray:array2];
        NSDictionary * dic = mutableArray1[sourceIndexPath.item];
        [mutableArray1 removeObjectAtIndex:sourceIndexPath.item];
        [mutableArray2 insertObject:dic atIndex:destinationIndexPath.item];
        NSData * data3 = [NSJSONSerialization dataWithJSONObject:mutableArray1 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data3 forKey:@"articleTopArr"];
        NSData *data4 = [NSJSONSerialization dataWithJSONObject:mutableArray2 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data4 forKey:@"articleBottomArr"];
    } else { // 交换item
        NSLog(@"交换===%ldto%ld",(long)sourceIndexPath.item,(long)destinationIndexPath.item);
        //存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data1 = [userDefault objectForKey:@"articleTopArr"];
        NSData * data2 = [userDefault objectForKey:@"articleBottomArr"];
        NSArray *array1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * mutableArray1 = [NSMutableArray arrayWithArray:array1];
        NSMutableArray * mutableArray2 = [NSMutableArray arrayWithArray:array2];
        NSDictionary * dic = mutableArray1[sourceIndexPath.item];
        [mutableArray1 removeObjectAtIndex:sourceIndexPath.item];
        [mutableArray1 insertObject:dic atIndex:destinationIndexPath.item];
        NSData * data3 = [NSJSONSerialization dataWithJSONObject:mutableArray1 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data3 forKey:@"articleTopArr"];
        NSData *data4 = [NSJSONSerialization dataWithJSONObject:mutableArray2 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data4 forKey:@"articleBottomArr"];
    }
    
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSMutableArray *section0 = self.dataSource.firstObject;
        NSMutableArray *section1 = self.dataSource.lastObject;
        JKNewsChannel *channal = section1[indexPath.item];
        [section1 removeObject:channal];
        channal.canShowDeleteView = YES;
        channal.showDeleteView = self.isEditing;
        [section0 addObject:channal];
        NSLog(@"添加===%ld",(long)indexPath.item);
        [collectionView reloadData];
        //存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data1 = [userDefault objectForKey:@"articleTopArr"];
        NSData * data2 = [userDefault objectForKey:@"articleBottomArr"];
        NSArray *array1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * mutableArray1 = [NSMutableArray arrayWithArray:array1];
        NSMutableArray * mutableArray2 = [NSMutableArray arrayWithArray:array2];
        NSDictionary * dic = mutableArray1[indexPath.item];
        [mutableArray2 removeObjectAtIndex:indexPath.item];
        [mutableArray1 addObject:dic];
        NSData * data3 = [NSJSONSerialization dataWithJSONObject:mutableArray1 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data3 forKey:@"articleTopArr"];
        NSData *data4 = [NSJSONSerialization dataWithJSONObject:mutableArray2 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data4 forKey:@"articleBottomArr"];
    }
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 40);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JKChannelHeaderView *headerView = [collectionView   dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader   withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        headerView.jkDelegate = self;
        headerView.channelEdit = self.channelEditArr[indexPath.section];
        return headerView;
    }
    return nil;
}

#pragma mark - ChannalHeaderViewDelegate
- (void)JKChannelHeaderView:(JKChannelHeaderView *)headerView didClickEditButton:(BOOL)isEditing{
    self.isEditing = isEditing;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_NewsChannelEditing" object:@(isEditing)]; // 发通知给所以item，显示删除按钮
}
#pragma mark -NewsChannalCellDelegate
- (void)JKNewsChannelCell:(JKNewsChannelCell *)cell didClickDeleteBtn:(BOOL)isDelete{
    if (isDelete) {
        NSMutableArray *section0 = self.dataSource.firstObject;
        NSMutableArray *section1 = self.dataSource.lastObject;
        JKNewsChannel *channal = cell.channel;
        NSInteger item = [section0 indexOfObject:channal];
        
        [section0 removeObject:channal];
        channal.canShowDeleteView = NO;
        channal.showDeleteView = NO;
        [section1 addObject:channal];
        NSLog(@"点击删除%ld",(long)item);
        [self.collectionView reloadData];
        //存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data1 = [userDefault objectForKey:@"articleTopArr"];
        NSData * data2 = [userDefault objectForKey:@"articleBottomArr"];
        NSArray *array1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSArray *array2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * mutableArray1 = [NSMutableArray arrayWithArray:array1];
        NSMutableArray * mutableArray2 = [NSMutableArray arrayWithArray:array2];
        NSDictionary * dic = mutableArray1[item];
        [mutableArray1 removeObjectAtIndex:item];
        [mutableArray2 addObject:dic];
        NSData * data3 = [NSJSONSerialization dataWithJSONObject:mutableArray1 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data3 forKey:@"articleTopArr"];
        NSData *data4 = [NSJSONSerialization dataWithJSONObject:mutableArray2 options:NSJSONWritingPrettyPrinted error:nil];
        [userDefault setObject:data4 forKey:@"articleBottomArr"];
    }
}
- (void)gotoMain{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firstLogin" object:nil];
}
@end
