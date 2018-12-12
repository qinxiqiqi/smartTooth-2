//
//  QXMovieController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXMovieController.h"
#import "ToothManager.h"
#import "QXBindingWifiController.h"
#import "QXWifiModel.h"
#import "WifiListView.h"
#import "QXBindingWifiController.h"
#import "QXVideoWebController.h"
#import "QXVideoController.h"
#import "QXBindingView.h"
#import "QXVideoView.h"
#import "JDAlertCustom.h"
@interface QXMovieController ()<ToothManagerDelegate,WifiListViewDelegate>
@property (nonatomic, strong) WifiListView *wifiView;
@property (nonatomic, strong) QXBindingView *bindingView;
@property (nonatomic, strong) QXVideoView *videoView;
@property (nonatomic, strong) NSArray *wifiList;
@end

@implementation QXMovieController

- (WifiListView *)wifiView
{
    if (!_wifiView) {
        _wifiView = [[WifiListView alloc] init];
        _wifiView.delegate = self;
    }
    return _wifiView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [ToothManager shareManager].delegate = self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initView {
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.bindingView];
    __weak typeof(self)weakSelf = self;
    self.videoView.flipToBindingAction = ^{
        [weakSelf flipToBindingAction];
    };
    self.videoView.linkVideoAction = ^{
        [weakSelf toConnectVideo];
    };
    self.bindingView.flipToVideoAction = ^{
        [weakSelf flipToVideoAction];
    };
    self.bindingView.bindingToothAction = ^{
        [weakSelf toBindingWifi];
    };
}
- (void)flipToBindingAction {
    [UIView transitionFromView:self.videoView toView:self.bindingView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
    }];
}
- (void)flipToVideoAction {
    [UIView transitionFromView:self.bindingView toView:self.videoView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
    }];
}

//绑定设备
- (void)toBindingWifi {
    [[ToothManager shareManager] disConnectTcpSocket];//连之前先断开
    [[ToothManager shareManager] initTcpSocketWithIpaaddr:ToothDefaultIP port:ToothDefaultPort];
}

- (void)toConnectVideo {

    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (user.isBinding == 1) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/?action=stream",user.ipaddr,user.port];
        //NSString *urlStr = @"http://192.168.31.181:8080/?action=stream";
        QXVideoController *videoVC = [[QXVideoController alloc] init];
        videoVC.url = urlStr;
        [self.navigationController pushViewController:videoVC animated:YES];
    } else {
        [JDAlertCustom alertWithMessage:@"您还未绑定牙刷，请先去绑定牙刷！" superVC:self];
    }
}

#pragma mark - ToothManagerDelegate
- (void)toothManager:(ToothManager *)manager getWifiList:(NSArray *)wifiList
{
    self.wifiList = wifiList;
    [self showWifiView];
}

- (void)wifiListView:(WifiListView *)wifiView didClickWifi:(QXWifiModel *)wifi
{
    QXBindingWifiController *bindingVC = [[QXBindingWifiController alloc] init];
    bindingVC.wifiModel = wifi;
    [self.navigationController pushViewController:bindingVC animated:YES];
    __weak typeof(self)weakSelf = self;
    bindingVC.bindingOverTime = ^{//超时则重新让用户选择wifi
        [weakSelf performSelector:@selector(showWifiView) withObject:nil afterDelay:2];
    };
}
- (void)showWifiView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wifiView removeFromSuperview];
        [self.wifiView showInView:self.view.window];
        self.wifiView.dataArray = self.wifiList;
    });
}

- (QXBindingView *)bindingView
{
    if (!_bindingView) {
        _bindingView = [[QXBindingView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        _bindingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _bindingView.center = self.view.center;
    }
    return _bindingView;
}
- (QXVideoView *)videoView
{
    if (!_videoView) {
        _videoView = [[QXVideoView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        _videoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _videoView.center = self.view.center;
    }
    return _videoView;
}
@end
