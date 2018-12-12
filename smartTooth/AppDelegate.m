//
//  AppDelegate.m
//  SmartTooth
//
//  Created by qinxi on 2018/7/31.
//  Copyright © 2018年 zhineng. All rights reserved.
//
#define EMAppKey @"1152170326178749#yayionline"
#define EMCerName @"istore_dev"

#import "AppDelegate.h"
#import "QXLoginController.h"
#import "QXMainViewController.h"
#import "QXNavigationController.h"
#import "MyNavigationController.h"
#import "LocationManager.h"
#import <JPUSHService.h>
#import <YZBaseSDK/YZBaseSDK.h>
#import "ToothManager.h"
@interface AppDelegate()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*获取token*/
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (ISNULL(user) || ISNULL(user.userId)) {
        QXLoginController *loginVC = [[QXLoginController alloc] init];
        MyNavigationController *navi = [[MyNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
    } else {
        QXMainViewController *mainVC = [[QXMainViewController alloc] init];
        self.window.rootViewController = mainVC;
    }
    [self.window makeKeyAndVisible];
    //环信
    [self initEaseMssageApplication:application options:launchOptions];
    
    //获取用户位置
    [self startLocation];
    
    //极光
    [self JPush:launchOptions];
    //注册apns推送
    [self registerApns:application];
    //有赞商城
    [self initYZSDK];
    
    //获取可用城市列表
    [[ToothManager shareManager] getCityList];
//    //链接UDP
    //[[ToothManager shareManager] initUdpSocket];
    
    return YES;
}
- (void)registerApns:(UIApplication *)application {
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound |   UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
}


- (void)initEaseMssageApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    
    //环信客服云
    HOptions *option = [[HOptions alloc] init];
    option.appkey = EMAppKey; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = @"59640";// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
    option.apnsCertName = EMCerName;//(集成离线推送必填)
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
        NSLog(@"-----------环信客服云集成失败");
    }
    
}

//开始定位，获取用户当前城市
- (void)startLocation
{
    LocationManager *manager = [LocationManager shareManager];
    [manager beginLocation];//开启定位
    manager.locationGet = ^(NSString *location,NSString *detail) {//获取位置
        NSString *city = [location substringToIndex:location.length];
        JZUserInfo *user = [JZUserInfo unarchiveObject];
        if (!user) {
            user = [[JZUserInfo alloc] init];
        }
        user.location = city;
        [JZUserInfo archiveObject:user];
    };
}
- (void)initYZSDK {
    YZConfig *config = [[YZConfig alloc] initWithClientId:@""];
    NSString* scheme = [[[NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"] firstObject][@"CFBundleURLSchemes"] firstObject];
    config.scheme = scheme;
    [YZSDK.shared initializeSDKWithConfig:config];
}


#pragma mark ---      友盟分享登录 极光推送
- (void)JPush:(NSDictionary *)launchOptions
{
    
    //    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //
    //    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"1bc93a0af3f9a232e05c0ac2"
                          channel:@"APP store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    [JPUSHService registrationIDCompletionHandler:nil];
    
    [[HChatClient sharedClient] bindDeviceToken:deviceToken];
}



//实现APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if (@available(iOS 10.0, *)) {
//        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//            [JPUSHService handleRemoteNotification:userInfo];
//        }
//    } else {
//        // Fallback on earlier versions
//    }
//    if (@available(iOS 10.0, *)) {
//        completionHandler(UNNotificationPresentationOptionAlert);
//    } else {
//        // Fallback on earlier versions
//    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//}

-(void)dealloc
{
    [[ToothManager shareManager] disConnectTcpSocket];
    [[ToothManager shareManager] disConnectUdpSocket];
}
@end
