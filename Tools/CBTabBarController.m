//
//  CBTabBarController.m
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBTabBarController.h"
#import "CBNewsViewController.h"
#import "CBVideoViewController.h"
#import "CBPictureViewController.h"
#import "CBPersonViewController.h"

@interface CBTabBarController ()
@property (nonatomic, weak) CBNewsViewController * newsListVC; // 新闻列表
@property (nonatomic, weak) CBVideoViewController * videosListVC; // 视频列表
@property (nonatomic, weak) CBPictureViewController * pictureListVC; // 图集列表
@property (nonatomic, weak) CBPersonViewController * personVC; // 个人中心
@end

@implementation CBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tabBar基本属性
    [self setTabBarAttribute];
    // 设置navigation导航栏属性(这个控制器只创建一次，需要设置navigation一次就可以)
    [self setNavigationBarAttribute];
    // 添加子控制器
    [self addChildViewControllers];
}

- (void)setTabBarAttribute{
    
    UITabBarItem *item = [UITabBarItem appearance];
    // 设置导航条按钮的文字颜色
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = MainThemeColor;
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    
    UITabBar *tabbar = [UITabBar appearance];
    tabbar.backgroundImage = [UIImage imageWithColor:[UIColor yellowColor]]; // 设置背景
    tabbar.tintColor = MainThemeColor;
    //     tabbar.barTintColor = [UIColor whiteColor];
    //    tabbar.selectionIndicatorImage = [UIImage imageWithColor:TTWhiteColor];
    tabbar.shadowImage = [UIImage new];
    
}

- (void)setNavigationBarAttribute{
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:UIBarMetricsDefault]; // 在push搜索控制器的时候会出问题
    //    navigationBar.barTintColor = TTMainThemeColor;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:MainThemeColor] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    NSMutableDictionary *navigationBarAttr = [NSMutableDictionary dictionary];
    navigationBarAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    navigationBarAttr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navigationBar setTitleTextAttributes:navigationBarAttr];
    // UIBarButtonItem设置
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    // 正常状态
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    
    [barButtonItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    
    
}

- (void)addChildViewControllers{
    self.newsListVC = (CBNewsViewController *)[self addChildViewController:[CBNewsViewController new] title:@"新闻" image:@"tab_news_normal" selectedImage:@"tab_news_height"];
    self.videosListVC = (CBVideoViewController *)[self addChildViewController:[CBVideoViewController new] title:@"视频" image:@"tab_video_normal" selectedImage:@"tab_video_height"];
    self.pictureListVC = (CBPictureViewController *)[self addChildViewController:[[CBPictureViewController alloc]init] title:@"图集" image:@"tab_picture_normal" selectedImage:@"tab_picture_height"];
    self.personVC = (CBPersonViewController *)[self addChildViewController:[[CBPersonViewController alloc]init] title:@"我的" image:@"tab_me_normal" selectedImage:@"tab_me_height"];
}

#pragma mark - 添加子控制器
- (UIViewController *)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    childController.tabBarItem.image = [UIImage imageNamed:image];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    //    childController.tabBarItem.title = title;
    childController.title = title;
    JPNavigationController *navigation = [[JPNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:navigation];
    return childController;
}

@end
