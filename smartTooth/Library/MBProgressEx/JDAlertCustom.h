//
//  JDAlertCustom.h
//  JiangDiet
//
//  Created by yanghengzhan on 2016/11/19.
//  Copyright © 2016年 yanghengzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface JDAlertCustom : NSObject


+ (instancetype)currentView;

- (void)alertViewWithMessage:(NSString *)message;

//+ (void)alertWithMessage:(NSString *)message title:(NSString*)title;
+ (void)alertWithMessage:(NSString *)message superVC:(UIViewController *)VC;
+ (void) hideTabBar:(UITabBarController *) tabbarcontroller;
+ (void) showTabBar:(UITabBarController *) tabbarcontroller;
@end
