//
//  JDAlertCustom.m
//  JiangDiet
//
//  Created by yanghengzhan on 2016/11/19.
//  Copyright © 2016年 yanghengzhan. All rights reserved.
//

#import "JDAlertCustom.h"
#import "MBProgressHUD.h"
static JDAlertCustom *_currentView;

@implementation JDAlertCustom

+ (instancetype)currentView
{
    static JDAlertCustom *defaultAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultAlert = [[JDAlertCustom alloc] init];
    });
    return defaultAlert;
}
- (void)alertViewWithMessage:(NSString *)message{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil,nil];
    [alert show];
}
+ (void)alertWithMessage:(NSString *)message superVC:(UIViewController *)VC{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
//        DebugLog(@"确定");
    }]];
    
    [VC presentViewController:alert animated:YES completion:nil];
}


+(void) hideTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    [UIView commitAnimations];
}

+(void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        //        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}


@end
