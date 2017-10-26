//
//  CBNewsViewController.m
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBNewsViewController.h"
#import "JKNewsChannelController.h"
#import "CBArticleListController.h"
#import "JKNewsChannelView.h"
#import "JKType.h"
#import "UIView+JKExtension.h"

@interface CBNewsViewController ()<UIScrollViewDelegate,JKNewsChannelViewDelegate,JKNewsChannelControllerDelegate>
@property (nonatomic, strong) JKNewsChannelView * channelsView;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) NSMutableArray * myChannels; // 我的频道
@property (nonatomic, strong) NSMutableArray * recommendChannels; // 推荐频道
@property (nonatomic, strong) NSMutableArray * childControllers; // 子控制器数组

@end

@implementation CBNewsViewController

- (NSMutableArray *)recommendChannels{
    if (!_recommendChannels) {
        _recommendChannels = [NSMutableArray array];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data = [userDefault objectForKey:@"articleBottomArr"];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < array.count; i++) {
            JKType *type = [JKType new];
            type.title = array[i][@"name"];
            type.type = array[i][@"id"];
            [_recommendChannels addObject:type];
        }
    }
    return _recommendChannels;
}

- (NSMutableArray *)childControllers{
    if (!_childControllers) {
        _childControllers = [NSMutableArray array];
    }
    return _childControllers;
}

- (JKNewsChannelView *)channelsView{
    if (!_channelsView) {
        _channelsView = [JKNewsChannelView newsChannelsView];
        _channelsView.newsChannels = self.myChannels;
        _channelsView.jkDelegate = self;
    }
    return _channelsView;
}

- (NSMutableArray *)myChannels{
    if (_myChannels == nil) {
        _myChannels = [NSMutableArray array];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data = [userDefault objectForKey:@"articleTopArr"];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i < array.count; i++) {
            JKType *type = [JKType new];
            type.title = array[i][@"name"];
            type.type = array[i][@"id"];
            [_myChannels addObject:type];
        }
    }
    return _myChannels;
}
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        UIScrollView *mainScrollView = [[UIScrollView alloc] init];
        mainScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        mainScrollView.pagingEnabled = YES;
        mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator = NO;
        mainScrollView.delegate = self;
        mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView = mainScrollView;
    }
    return _mainScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view addSubview:self.channelsView];
    [self.view addSubview:self.mainScrollView];
    // 添加子控制器
    [self setChildViewControllers];
    [self addChildVcView];
}
#pragma mark - 添加子控制器
- (void)setChildViewControllers{
    for (int i = 0; i < self.myChannels.count; i++){
        CBArticleListController * articleList = [CBArticleListController new];
        JKType * type = self.myChannels[i];
        articleList.articleID = type.type;
        [self addChildViewController:articleList];
        [self.childControllers addObject:articleList];
    }
    self.mainScrollView.contentSize = CGSizeMake(self.childControllers.count * self.mainScrollView.frame.size.width, 0);
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView{
    NSUInteger index = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    UIViewController *childVc = self.childControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.mainScrollView.bounds;
    [self.mainScrollView addSubview:childVc.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //根据滑动的效果实现头部标题栏的效果（标题文字效果）
    NSInteger currentIndex = (NSInteger)scrollView.contentOffset.x/scrollView.frame.size.width;
    NSInteger nextIndex = (scrollView.contentOffset.x > scrollView.frame.size.width * currentIndex) ? currentIndex+1:currentIndex-1;
    CGFloat rate_i = (scrollView.contentOffset.x - scrollView.frame.size.width * currentIndex)/scrollView.frame.size.width;
    [self.channelsView transformStatusWithCurrentIndex:currentIndex nextIndex:nextIndex withRate:rate_i];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = (NSInteger)scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.channelsView scrollerToCenterWithIndex:currentIndex];
    [self addChildVcView];
}

#pragma mark - JKNewsChannelsViewDelegate
- (void)JKNewsChannelsView:(JKNewsChannelView *)newsChannelsView didSelectedNewsChannelItemAtIndex:(NSInteger)index{
    [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*index, 0) animated:NO];
    [self addChildVcView];
}

- (void)JKNewsChannelsView:(JKNewsChannelView *)newsChannelsView didSelectedAddNewsChannelButton:(BOOL)selected{
    if (selected) {
        JKNewsChannelController *channelsVC = [JKNewsChannelController new];
        channelsVC.dataSource = @[self.myChannels,self.recommendChannels];
        channelsVC.currentIndex = self.channelsView.currentIndex;
        channelsVC.jkDelegate = self;
        channelsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:channelsVC animated:YES];
    }
}

#pragma mark - JKNewsChannelControllerDelegate
- (void)JKNewsChannelController:(JKNewsChannelController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.channelsView selectNewsChannelsItemWithIndex:indexPath.item];
}

- (void)JKNewsChannelController:(JKNewsChannelController *)controller didAddItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.myChannels addObject:self.recommendChannels[indexPath.item]]; // 将新频道添加到我的频道末尾
    [self.recommendChannels removeObjectAtIndex:indexPath.item]; // 从推荐数组中删除数据
    self.channelsView.newsChannels = self.myChannels; // 重新布局频道列表
    CBArticleListController * content = [CBArticleListController new];
    [self addChildViewController:content];
    [self.childControllers addObject:content];
    self.mainScrollView.contentSize = CGSizeMake(self.childControllers.count * self.mainScrollView.frame.size.width, 0);
}

- (void)JKNewsChannelController:(JKNewsChannelController *)controller didDeleteItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    JKType *deletedChannel = self.myChannels[sourceIndexPath.item];
    [self.myChannels removeObject:deletedChannel];
    [self.recommendChannels insertObject:deletedChannel atIndex:destinationIndexPath.item];
    UIViewController *childVC = (UIViewController *)self.childControllers[sourceIndexPath.item];
    if ([childVC isViewLoaded]) {
        [childVC.view removeFromSuperview];
    }
    [self.childControllers removeObject:childVC];
    [childVC removeFromParentViewController];
    self.mainScrollView.contentSize = CGSizeMake(self.childControllers.count * self.mainScrollView.frame.size.width, 0);
    for (NSInteger i = sourceIndexPath.item; i < self.childControllers.count; i++) {
        UIViewController *vc = self.childControllers[i];
        if ([vc isViewLoaded]) {
            vc.view.jk_x = i*self.mainScrollView.frame.size.width;
        }
    }
    if (self.channelsView.currentIndex == sourceIndexPath.item) { // 如果当先的频道被删除，则选中第一个频道
        self.channelsView.currentIndex = 0;
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
    } else if (self.channelsView.currentIndex < sourceIndexPath.item){ // 如果删除的频道在当前频道的后面，只需要更新布局
    } else if (self.channelsView.currentIndex > sourceIndexPath.item){ // 如果删除的频道在当前频道的前面，需要将当前的频道索引-1
        self.channelsView.currentIndex -= 1;
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
    }
    self.channelsView.newsChannels = self.myChannels; // 重新布局频道列表
}

- (void)JKNewsChannelController:(JKNewsChannelController *)controller moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    JKType *sourceChannel = self.myChannels[sourceIndexPath.item];
    [self.myChannels removeObject:sourceChannel];
    [self.myChannels insertObject:sourceChannel atIndex:destinationIndexPath.item];
    // 子控制器数组
    UIViewController *sourceVC = self.childControllers[sourceIndexPath.item];
    [self.childControllers removeObject:sourceVC];
    [self.childControllers insertObject:sourceVC atIndex:destinationIndexPath.item];
    // scrollerView的子view位置
    if ([sourceVC isViewLoaded]) {
        sourceVC.view.jk_x = destinationIndexPath.item * self.mainScrollView.frame.size.width;
    }
    NSInteger currentIndex = self.channelsView.currentIndex;
    if (sourceIndexPath.item < destinationIndexPath.item) { // 往后挪
        for (NSInteger i = sourceIndexPath.item; i < destinationIndexPath.item; i++) {
            UIViewController *vc = self.childControllers[i];
            if ([vc isViewLoaded]) {
                vc.view.jk_x = i*self.mainScrollView.frame.size.width;
            }
        }
        if (currentIndex == sourceIndexPath.item) {
            self.channelsView.currentIndex = destinationIndexPath.item;
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
        } else if (currentIndex > sourceIndexPath.item && currentIndex <= destinationIndexPath.item){
            self.channelsView.currentIndex -= 1;
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
        }
    } else { // 往前挪
        for (NSInteger i = destinationIndexPath.item + 1; i <= sourceIndexPath.item; i++) {
            UIViewController *vc = self.childControllers[i];
            if ([vc isViewLoaded]) {
                vc.view.jk_x = i*self.mainScrollView.frame.size.width;
            }
        }
        if (currentIndex == sourceIndexPath.item) {
            self.channelsView.currentIndex = destinationIndexPath.item;
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
        } else if (currentIndex >= destinationIndexPath.item && currentIndex < sourceIndexPath.item){
            self.channelsView.currentIndex += 1;
            [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*self.channelsView.currentIndex, 0) animated:NO];
        }
    }
    self.channelsView.newsChannels = self.myChannels; // 重新布局频道列表
}


@end
