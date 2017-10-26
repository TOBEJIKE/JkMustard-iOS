//
//  JKNewsChannelController.m
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKNewsChannelController.h"
#import "JKNewsChannel.h"
#import "JKNewsChannelCell.h"
#import "JKNewsChannelEdit.h"
#import "JKChannelHeaderView.h"
#import "JKType.h"

@interface JKNewsChannelController ()<UICollectionViewDelegate,UICollectionViewDataSource,JKNewsChannelCellDelegate,JKChannelHeaderViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isEditing; // 频道是否正在处于编辑状态
@property (nonatomic, strong) NSMutableArray *channelEditArr; // 频道编辑状态数组
@end

@implementation JKNewsChannelController

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
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
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
    [self.view addSubview:self.collectionView];
    NSMutableArray *myChannels = self.dataSource.firstObject;
    JKNewsChannel *channel = myChannels[self.currentIndex];
    channel.isSelected = YES;
}
#pragma mark - 重写数据源
- (void)setDataSource:(NSArray *)dataSource{
    NSMutableArray *my = [NSMutableArray array];
    NSArray *myChannels = dataSource.firstObject;
    for (int i = 0; i < myChannels.count; i++) {
        JKType *type = myChannels[i];
        JKNewsChannel *channel = [JKNewsChannel new];
        channel.canShowDeleteView = YES;
        channel.showDeleteView = NO;
        channel.text = type.title;
        [my addObject:channel];
    }
    NSMutableArray *recommends = [NSMutableArray array];
    NSArray *recommendChannels = dataSource.lastObject;
    for (int i = 0; i < recommendChannels.count; i++) {
        JKType *type = recommendChannels[i];
        JKNewsChannel *channel = [JKNewsChannel new];
        channel.text = type.title;
        channel.canShowDeleteView = NO;
        channel.showDeleteView = NO;
        [recommends addObject:channel];
    }
    _dataSource = @[my,recommends];
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
    JKNewsChannel *channel = sourceArr[sourceIndexPath.item];
    [sourceArr removeObject:channel];
    NSMutableArray *destinationArr = self.dataSource[destinationIndexPath.section];
    [destinationArr insertObject:channel atIndex:destinationIndexPath.item];
    if (destinationIndexPath.section == 1) {
        channel.canShowDeleteView = NO;
        channel.showDeleteView = NO;
        if (channel.isSelected) { // 当前选中的频道被删除后，默认选中第一条频道
            channel.isSelected = NO; // 取消选中状态
            NSMutableArray *myChannels = self.dataSource.firstObject;
            for (JKNewsChannel *channel in myChannels) {
                channel.isSelected = NO;
            }
            JKNewsChannel *mychannel = myChannels[0];
            mychannel.isSelected = YES;
        }
        [collectionView reloadData];
    }
    if (destinationIndexPath.section == 1) { // 删除item
        if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelController:didDeleteItemAtIndexPath:toIndexPath:)]) {
            [self.jkDelegate JKNewsChannelController:self didDeleteItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
    } else { // 交换item
        if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelController:moveItemAtIndexPath:toIndexPath:)]) {
            [self.jkDelegate JKNewsChannelController:self moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSMutableArray *myChannels = self.dataSource.firstObject;
        NSMutableArray *recommendChannels = self.dataSource.lastObject;
        JKNewsChannel *channel = recommendChannels[indexPath.item];
        [recommendChannels removeObject:channel];
        channel.canShowDeleteView = YES;
        channel.showDeleteView = self.isEditing;
        [myChannels addObject:channel];
        if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelController:didAddItemAtIndexPath:)]) {
            [self.jkDelegate JKNewsChannelController:self didAddItemAtIndexPath:indexPath];
        }
    } else {
        if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelController:didSelectItemAtIndexPath:)]) {
            [self.jkDelegate JKNewsChannelController:self didSelectItemAtIndexPath:indexPath];
        }
        NSMutableArray *myChannels = self.dataSource[indexPath.section];
        for (JKNewsChannel *channel in myChannels) {
            channel.isSelected = NO;
        }
        JKNewsChannel *channel = myChannels[indexPath.item];
        channel.isSelected = YES;
        
    }
    [collectionView reloadData];
    
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 40);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JKChannelHeaderView *headerView = [collectionView   dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader   withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
        headerView.jkDelegate = self;
        headerView.channelEdit = self.channelEditArr[indexPath.section];
        return headerView;
    }
    return nil;
}

#pragma mark -TTNewsChannelCellDelegate
- (void)JKNewsChannelCell:(JKNewsChannelCell *)cell didClickDeleteBtn:(BOOL)isDelete{
    if (isDelete) {
        NSMutableArray *myChannels = self.dataSource.firstObject;
        NSMutableArray *recommendChannels = self.dataSource.lastObject;
        JKNewsChannel *channel = cell.channel;
        NSInteger item = [myChannels indexOfObject:channel];
        [myChannels removeObject:channel];
        channel.canShowDeleteView = NO;
        channel.showDeleteView = NO;
        [recommendChannels addObject:channel];
        if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelController:didDeleteItemAtIndexPath:toIndexPath:)]) {
            [self.jkDelegate JKNewsChannelController:self didDeleteItemAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] toIndexPath:[NSIndexPath indexPathForRow:[self.dataSource.lastObject count] - 1 inSection:1]];
        }
        if (channel.isSelected) { // 当前选中的频道被删除后，默认选中第一条频道
            channel.isSelected = NO; // 取消选中状态
            NSMutableArray *myChannels = self.dataSource.firstObject;
            JKNewsChannel *mychannel = myChannels[0];
            mychannel.isSelected = YES;
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - TTChannelHeaderViewDelegate
- (void)JKChannelHeaderView:(JKChannelHeaderView *)headerView didClickEditButton:(BOOL)isEditing{
    self.isEditing = isEditing;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_NewsChannelEditing" object:@(isEditing)]; // 发通知给所以item，显示删除按钮
}

@end
