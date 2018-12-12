//
//  QXToothSetupController.m
//  smartTooth
//
//  Created by qinxi on 2018/11/8.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXToothSetupController.h"
#import "QXToothStyleView.h"
#import "QXToothTimeView.h"
#import "ToothManager.h"

@interface QXToothSetupController ()
@property (nonatomic, strong) QXToothStyleView *styleView;
@property (nonatomic, strong) QXToothTimeView *timeView;
/** 选择的模式*/
@property (nonatomic, assign) NSInteger selectSmode;
/** 选择的时间*/
@property (nonatomic, assign) NSInteger selectTime;
@end

@implementation QXToothSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个性化定制";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    self.selectSmode = user.smode;
    if (user.smode == 0) {
        self.selectTime = user.smodetime0;
    } else if (user.smode == 1) {
        self.selectTime = user.smodetime1;
    } else if (user.smode == 2) {
        self.selectTime = user.smodetime2;
    }
    if (self.selectTime == 0) {//默认为4；
        self.selectTime = 4;
    }
}

- (void)initView {
    [self.view addSubview:self.styleView];
    [self.view addSubview:self.timeView];
    __weak typeof(self)weakSelf = self;
    self.styleView.toothStyleSelect = ^(NSInteger selectStyle) {
        weakSelf.selectSmode = selectStyle;
    };
    self.timeView.toothTimeSelect = ^(NSInteger selectTime) {
        weakSelf.selectTime = selectTime;
    };
    
    CGFloat btnW = ScreenWidth - 80;
    CGFloat btnH = (ScreenWidth - 80) * 156 / 678;
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, ScreenHeight - 30 - btnH , btnW, btnH)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L-select"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)saveBtnClicked {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"smode"] = @(self.selectSmode);
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (self.selectSmode == 0) {
        dict[@"smodetime0"] = @(self.selectTime);
        user.smodetime0 = self.selectTime;
    } else if (self.selectSmode == 1) {
        dict[@"smodetime1"] = @(self.selectTime);
        user.smodetime1 = self.selectTime;
    } else if (self.selectSmode == 2) {
        dict[@"smodetime2"] = @(self.selectTime);
        user.smodetime2 = self.selectTime;
    }
    
    __weak typeof(self)weakSelf = self;
    [[ToothManager shareManager] updateToothInfo:dict success:^{
        [MBProgressHUD showSuccess:@"设置成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (QXToothStyleView *)styleView
{
    if (!_styleView) {
        _styleView = [[QXToothStyleView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + WidthScale6(30), ScreenWidth, WidthScale6(234))];
    }
    return _styleView;
}

- (QXToothTimeView *)timeView
{
    if (!_timeView) {
        _timeView = [[QXToothTimeView alloc] initWithFrame:CGRectMake(0, self.styleView.bottom + WidthScale6(50), ScreenWidth, WidthScale6(200))];
    }
    return _timeView;
}

@end
