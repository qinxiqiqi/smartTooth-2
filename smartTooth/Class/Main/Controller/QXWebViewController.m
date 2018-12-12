//
//  QXWebViewController.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/22.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXWebViewController.h"
#import <WebKit/WebKit.h>

@interface QXWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation QXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
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


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
