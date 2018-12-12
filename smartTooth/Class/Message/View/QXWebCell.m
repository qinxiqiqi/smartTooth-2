//
//  JZAudioDetailInfo.m
//  Everyday
//
//  Created by qinxi on 2018/10/17.
//  Copyright © 2018年 Jiuzhou. All rights reserved.
//

#import "QXWebCell.h"

@interface QXWebCell()<WKNavigationDelegate>
@property (nonatomic, assign) CGFloat webViewH;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation QXWebCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXWebCell"];
    if (!cell) {
        cell = [[QXWebCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXWebCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    
    WKWebView *webView = [[WKWebView alloc] init];
    self.webView = webView;
    webView.scrollView.scrollEnabled = NO;
    webView.navigationDelegate = self;
    [self.contentView addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
    self.progressView.trackTintColor = UIColorHex(0xffffff);
    self.progressView.progressTintColor = UIColorHex(0x3594ff);
    [self.contentView addSubview:self.progressView];
    
    // 给webview添加监听
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)setRequestUrl:(NSString *)requestUrl
{
    if (!_requestUrl) {
        _requestUrl = requestUrl;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    }
}

#pragma mark - KVO回调
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{ NSLog(@"加载完成"); //这个方法也可以计算出webView滚动视图滚动的高度
    __weak typeof(self)weakSelf = self;
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat ratio = CGRectGetWidth(self.webView.frame) /[result floatValue];
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]); [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
            [weakSelf reloadWebViewHeight:[result floatValue]*ratio];
        }];
        
    }];
    
}
- (void)reloadWebViewHeight:(CGFloat)webViewH {
    if (_delegate && [_delegate respondsToSelector:@selector(webViewLoadFinish:)]) {
        [self.delegate webViewLoadFinish:webViewH];
    }
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
@end
