//
//  MyNavigationController.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = true;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    UINavigationBar* bar = self.navigationBar;
    // 1.设置导航条的背景色
    [bar setBarTintColor:UIColorForX(0xffffff)];
    // 2.设置左右按钮的渲染颜色
    [bar setTintColor:UIColorHex(0x333333)];
    // 3.设置标题文字样式
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x333333)}];
    // 4.设置返回按钮的箭头
    [bar setBackIndicatorImage:[UIImage imageNamed:@"back-black"]];
    [bar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-black"]];
}

+(void)initialize
{
    
    //5.设置背景图
    
    //[bar setBackgroundImage:[UIImage imageNamed:@"navibg"] forBarMetrics:UIBarMetricsDefault];
    
}



//为了方便只要一push出二级页面，就自动隐藏底部的bar

//截获导航控制器的pushViewController方法

//先保证原有的push动作要完成，除此意外再多做一件事

//隐藏要推出的vc的底部bar

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 2.设置导航栏上面的内容
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked)];
        viewController.navigationItem.leftBarButtonItem.tintColor = UIColorHex(0x333333);
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backItemClicked {
    [self popViewControllerAnimated:YES];
}


@end
