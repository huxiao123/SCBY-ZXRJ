//
//  AppDelegate.h
//  SCBY-ZXRJ
//
//  Created by ios on 15/11/27.
//  Copyright © 2015年 ZXRJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign,nonatomic) BOOL isLogin;
@property (nonatomic,copy)NSString *SellerCode;
@property (nonatomic,copy)NSString *Manager_Name;
@property (nonatomic,copy)NSString *ID;//登录人的审批人ID


@property (strong, nonatomic) BMKMapManager *mapManager;

- (void)createNav;


@end

