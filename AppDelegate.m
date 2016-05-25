//
//  AppDelegate.m
//  SCBY-ZXRJ
//
//  Created by ios on 15/11/27.
//  Copyright © 2015年 ZXRJ. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "SetViewController.h"
#import "OtherViewController.h"
#import "APService.h"
#import "Notify.h"
#import "IQKeyboardManager.h"
#import "FourViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
//户

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (_isLogin==NO) {
        LoginViewController *log = [[LoginViewController alloc]init];
        self.window.rootViewController = log;
        
    }else{
        [self createNav];
    }
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    //设置百度地图
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"GKKAkKXFBIuZxkUsteQO7Bb3" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //设置键盘防遮挡输入框
   IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    return YES;
}


//创建导航控制器
- (void)createNav{
    
    NSArray *ctrArray = @[@"HomeViewController",
                          @"SetViewController",
                          @"OtherViewController",
                          @"FourViewController"];
    
    NSArray *titleArray = @[@"日常功能",
                            @"拜访管理",
                            @"其他",
                            @"设置"];
    
    NSArray *image = @[@"gn@2x",@"BFL",@"Other@2x",@"shzh@2x"];
    
    NSArray *heighImage = @[@"gnl@2x",@"BFL@2x",@"OtherL@2x",@"shzhl@2x"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i=0; i<ctrArray.count; i++) {
        
        Class class = NSClassFromString(ctrArray[i]);
        UIViewController *vc = [[class alloc]init];
        UINavigationController *nav = [[UINavigationController  alloc]initWithRootViewController:vc];
        
        vc.tabBarItem.title = titleArray[i];
        vc.tabBarItem.image = [UIImage imageNamed:image[i]]
        ;
        vc.tabBarItem.selectedImage = [UIImage imageNamed:heighImage[i]];
        [array addObject:nav];
        
    }
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = array;
    self.window.rootViewController = tabBar;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -----APService-----

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
      stringByReplacingOccurrencesOfString: @">" withString: @""]
     stringByReplacingOccurrencesOfString: @" " withString: @""];

    
    // Required（上传DeviceToken给极光推送的服务器）
    //这不是吗
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
   // NSLog(@"%@",userInfo);
    /*
     "_j_msgid" = 1236063462;
     aps =     {
     alert = fdf;
     badge = 1;
     sound = default;
     };
     */
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
