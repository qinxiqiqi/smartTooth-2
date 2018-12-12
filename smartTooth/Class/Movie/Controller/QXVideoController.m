//
//  QXVideoController.m
//  smartTooth
//
//  Created by qinxi on 2018/11/14.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXVideoController.h"
#import "MJPEGStreamLib.h"
#import "QXVideoFuncView.h"
@interface QXVideoController ()
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) MJPEGStreamLib *stream;
@property (nonatomic, strong) QXVideoFuncView *funcView;
/** 0：竖屏（默认） 1：横屏*/
@property (nonatomic, assign) NSInteger rotationType;
@end

@implementation QXVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.funcView];
    [self videoRotationAction];//直接切换到横屏
    
    [self setNaviBar];//返回
    
    __weak typeof(self)weakSelf = self;
    
    self.stream = [[MJPEGStreamLib alloc] initImageView:self.imageView contentURL:self.url];
    self.stream.didStartLoding = ^{
        [MBProgressHUD showMessage:@"" toView:weakSelf.view];
    };
    self.stream.didFinishLoding = ^{
        [weakSelf.funcView showView];//先展示出来
        [MBProgressHUD hideHUDForView:weakSelf.view];
    };
    [self.stream play];
}

- (void)setNaviBar {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 40, 10, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"close-white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



- (void)videoRotationAction {
    if (self.rotationType == 0) {//切换到横屏
        self.rotationType = 1;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _imageView.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        _imageView.frame = CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight);
        _funcView.frame = _imageView.bounds;
        [CATransaction commit];
    } else {//切换到竖屏
        self.rotationType = 0;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _imageView.transform = CGAffineTransformIdentity;
        _imageView.frame = CGRectMake(0, (ScreenHeight - ScreenWidth * 9 / 16)/2, ScreenWidth, ScreenWidth * 9 / 16);
        _funcView.frame = _imageView.bounds;
        [CATransaction commit];
    }
}

- (void)tapGR:(UITapGestureRecognizer *)tapGR {
    if (self.funcView.isShow) {
        [self.funcView hideView];
    } else {
        [self.funcView showView];
    }
}
- (void)backItemClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (YYAnimatedImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth * 9 / 16)/2, ScreenWidth, ScreenWidth * 9 / 16)];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [_imageView addGestureRecognizer:tapGR];
    }
    return _imageView;
}

- (QXVideoFuncView *)funcView
{
    if (!_funcView) {
        _funcView = [[QXVideoFuncView alloc] initWithFrame:self.imageView.bounds];
    }
    return _funcView;
}
@end
