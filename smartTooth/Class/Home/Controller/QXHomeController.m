//
//  QXHomeController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXHomeController.h"
#import <WebKit/WebKit.h>
#import "QXToothSetupController.h"
#import "JDAlertCustom.h"
@interface QXHomeController ()
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation QXHomeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"刷牙日记";
    [self.navigationController.navigationBar setBarTintColor:UIColorForX(0xffffff)];
    // 2.设置左右按钮的渲染颜色
    [self.navigationController.navigationBar setTintColor:UIColorHex(0x333333)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x666666),NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tooth_personal_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kTabBarHeight)];
    self.webView = webView;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ceshi.jumodel.cn/html?uid=80851431739c444c8a74836980756b35"]]];
    [self.view addSubview:webView];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, 2)];
    self.progressView.trackTintColor = UIColorHex(0xffffff);
    self.progressView.progressTintColor = UIColorHex(0x3594ff);
    [self.view addSubview:self.progressView];
    
    // 给webview添加监听
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}


- (void)rightItemClicked:(UIButton *)sender {
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (user.isBinding == YES) {
        QXToothSetupController *setupVC = [[QXToothSetupController alloc] init];
        [self.navigationController pushViewController:setupVC animated:YES];
    } else {
        [JDAlertCustom alertWithMessage:@"您还未绑定牙刷，请先去绑定牙刷！" superVC:self];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
