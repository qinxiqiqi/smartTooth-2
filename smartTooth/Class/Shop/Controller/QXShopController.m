//
//  QXShopController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXShopController.h"
#import <YZBaseSDK/YZBaseSDK.h>

@interface QXShopController ()
@property (nonatomic, strong) YZWebView *webView;
@end

@implementation QXShopController
- (YZWebView *)webView
{
    if (!_webView) {
        _webView = [[YZWebView alloc] initWithWebViewType:YZWebViewTypeUIWebView];
        _webView.frame = CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight - kTabBarHeight);
        _webView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://h5.youzan.com/xxxx"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
