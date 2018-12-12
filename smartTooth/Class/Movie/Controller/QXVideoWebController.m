//
//  QXVideoWebController.m
//  smartTooth
//
//  Created by qinxi on 2018/11/5.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXVideoWebController.h"
#import <WebKit/WebKit.h>

@interface QXVideoWebController ()<WKNavigationDelegate,WKUIDelegate>
{
    NSInteger _rotation;
}
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation QXVideoWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"看看";
    
    _rotation = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"旋转" style:UIBarButtonItemStylePlain target:self action:@selector(rotationClick)];
    
    [MBProgressHUD showSuccess:self.requestUrl];
    
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
- (void)rotationClick {
    _rotation++;
    if (_rotation == 4) {
        _rotation = 0;
    }
    self.webView.transform = CGAffineTransformMakeRotation(_rotation * M_PI / 2);
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


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD showError:@"加载失败！"];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{ NSLog(@"加载完成"); //这个方法也可以计算出webView滚动视图滚动的高度
    __weak typeof(self)weakSelf = self;
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio = CGRectGetWidth(self.webView.frame) /[result floatValue];
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]); [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
        }];
        
    }];
    
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
