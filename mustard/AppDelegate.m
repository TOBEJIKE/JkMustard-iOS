//
//  AppDelegate.m
//  mustard
//
//  Created by chinabyte on 2017/8/15.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "AppDelegate.h"
#import "CBGuideViewController.h"
#import "CBTabBarController.h"

@interface AppDelegate ()
@property (nonatomic,strong) NSString * isLogin;
@property (nonatomic,strong) NSString * filePatch;
@property (nonatomic,strong) NSMutableDictionary * sandBoxDataDic;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setUMeng];
    [self isLoginFirst];
    if ([self.isLogin isEqualToString:@"0"]) {
        [self loadSplash];
    }else{
        [self loadMainView];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootView) name:@"firstLogin" object:nil];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)setUMeng{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59523c0e4544cb7dcc000a6f"];
    [self configUSharePlatforms];
}
- (void)configUSharePlatforms{
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106178517"  appSecret:@"z0Za9GhztvEa8DyS" redirectURL:@"http://mobile.umeng.com/social"];
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf197ee18bd15f094" appSecret:@"8246c77a8fd7675575b1a88c91b85666" redirectURL:nil];
    //新浪
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2400084767"  appSecret:@"1880e8da28911bd15b30310c41d1075a" redirectURL:@"http://jiemo.chinabyte.com"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)isLoginFirst{
    //沙盒获取路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径没有会自动创建
    self.filePatch = [path stringByAppendingPathComponent:@"PropertyLoginList.plist"];
    self.sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:self.filePatch];
    if (self.sandBoxDataDic==nil) {
        self.sandBoxDataDic = [NSMutableDictionary new];
        self.sandBoxDataDic[@"isLogin"] = @"0";
        [self.sandBoxDataDic writeToFile:self.filePatch atomically:YES];
    }
    self.isLogin = [self.sandBoxDataDic objectForKey:@"isLogin"];
}
- (void)loadSplash{
    self.sandBoxDataDic[@"isLogin"] = @"1";
    [self.sandBoxDataDic writeToFile:self.filePatch atomically:YES];
    CBGuideViewController * guide = [[CBGuideViewController alloc]init];
    self.window.rootViewController = guide;
}
- (void)loadMainView{
    self.window.rootViewController = [CBTabBarController new];
}
- (void)changeRootView{
    [self loadMainView];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
