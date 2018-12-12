//
//  QXMainViewController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXMainViewController.h"
#import "QXHomeController.h"
#import "QXMovieController.h"
#import "QXShopController.h"
#import "QXZhiliaoController.h"
#import "QXProfileController.h"
#import "QXNavigationController.h"
#import "MyNavigationController.h"
#import "LocationManager.h"
#import "EaseConversationListViewController.h"
@interface QXMainViewController ()

@end

@implementation QXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    //    self.view.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    
    //[UITabBar appearance].backgroundImage =  [UIImage imageNamed:@"barBackground"];
    
    /**** 设置UITabBarItem的文字属性 ****/
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAttrs[NSForegroundColorAttributeName] =  [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = UIColorForX(0x2F71FF);
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (user.is_doctor) {
        EaseConversationListViewController *converListVC = [[EaseConversationListViewController alloc] init];
        MyNavigationController *converNavi=[[MyNavigationController alloc] initWithRootViewController:converListVC];
        [self setupOneChildViewController:converNavi title:@"咨询" image:@"jj-icon-grey" selectedImage:@"jj-icon-blue"];
        
        QXProfileController *profileVC = [[QXProfileController alloc] init];
        MyNavigationController *profileNavi = [[MyNavigationController alloc] initWithRootViewController:profileVC];
        [self setupOneChildViewController:profileNavi title:@"我的" image:@"my-icon-grey" selectedImage:@"my-icon-blue"];
        
    } else {
        /**** 添加子控制器 ****/
//        QXHomeController* homeVC =  [[QXHomeController alloc] init];
//        MyNavigationController *homeNavi=[[MyNavigationController alloc] initWithRootViewController:homeVC];
//        [self setupOneChildViewController:homeNavi title:@"洁净" image:@"jj-icon-grey" selectedImage:@"jj-icon-blue"];
        
        
//        QXMovieController* movieVc =  [[QXMovieController alloc] init];
//        QXNavigationController *movieNavi=[[QXNavigationController alloc] initWithRootViewController:movieVc];
//        [self setupOneChildViewController:movieNavi title:@"看看" image:@"kk-icon-grey" selectedImage:@"kk-icon-blue"];
        EaseConversationListViewController *converListVC = [[EaseConversationListViewController alloc] init];
        MyNavigationController *converNavi=[[MyNavigationController alloc] initWithRootViewController:converListVC];
        [self setupOneChildViewController:converNavi title:@"咨询" image:@"jj-icon-grey" selectedImage:@"jj-icon-blue"];
        
        QXZhiliaoController* messageVc =  [[QXZhiliaoController alloc] init];
        QXNavigationController *messageNavi=[[QXNavigationController alloc] initWithRootViewController:messageVc];
        [self setupOneChildViewController:messageNavi title:@"治疗" image:@"zl-icon-grey" selectedImage:@"zl-icon-blue"];
        
        
//        QXShopController* shopVc =  [[QXShopController alloc] init];
//        QXNavigationController *shopNavi=[[QXNavigationController alloc] initWithRootViewController:shopVc];
//        [self setupOneChildViewController:shopNavi title:@"呵护" image:@"hh-icon-grey" selectedImage:@"hh-icon-blue"];
        
        
        QXProfileController *profileVC = [[QXProfileController alloc] init];
        MyNavigationController *profileNavi = [[MyNavigationController alloc] initWithRootViewController:profileVC];
        [self setupOneChildViewController:profileNavi title:@"我的" image:@"my-icon-grey" selectedImage:@"my-icon-blue"];
    }
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
}


//开始定位，获取用户当前城市
- (void)startLocation
{
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if ([user.location isEqualToString:@""] || user.location == nil) {
        LocationManager *manager = [LocationManager shareManager];
        [manager beginLocation];//开启定位
        manager.locationGet = ^(NSString *location,NSString *detail) {//获取位置
            NSString *city = [location substringToIndex:location.length];
            user.location = city;
            [JZUserInfo archiveObject:user];
        };
    }
    
}
@end
