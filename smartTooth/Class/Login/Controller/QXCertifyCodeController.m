//
//  QXCertifyCodeController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/9.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXCertifyCodeController.h"
#import "QXMainViewController.h"
#import "ToothManager.h"
#import <HelpDesk/HelpDesk.h>
@interface QXCertifyCodeController ()<UITextFieldDelegate>
{
    NSTimeInterval _secondsAfterLastSend;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UITextField *codeField;
@property (nonatomic, weak) UIButton *getCodeBtn;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation QXCertifyCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    [self sendCode];
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
- (void)setupView {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 40, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back-black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, backBtn.bottom + 15, ScreenWidth, 29)];
    label.text = @"验证码已发至手机";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorHex(0x979797);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom, ScreenWidth, 30)];
    NSString *secretPhone = self.phone;
    if (self.phone.length > 7) {
        secretPhone = [self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    phoneLabel.text = secretPhone;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:24];
    phoneLabel.textColor = UIColorHex(0x333333);
    [self.view addSubview:phoneLabel];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, phoneLabel.bottom + 80, 58, 25)];
    leftLabel.text = @"验证码";
    leftLabel.font = [UIFont systemFontOfSize:18];
    leftLabel.textColor = UIColorHex(0x979797);
    [self.view addSubview:leftLabel];
    
    UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, leftLabel.top, 100, leftLabel.height)];
    self.getCodeBtn = getCodeBtn;
    [getCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [getCodeBtn setTitleColor:UIColorHex(0x0060f0) forState:(UIControlStateNormal)];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCodeBtn addTarget:self action:@selector(getCodeBtnDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:getCodeBtn];
    
    UIView *verticolLine = [[UIView alloc] initWithFrame:CGRectMake(getCodeBtn.left - 11, leftLabel.top + (leftLabel.height - 14)/2, 1, 14)];
    verticolLine.backgroundColor = UIColorHex(0xd2d5df);
    [self.view addSubview:verticolLine];
    
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, getCodeBtn.left - leftLabel.right, leftLabel.height)];
    self.codeField = codeField;
    codeField.font = [UIFont systemFontOfSize:18];
    codeField.textColor = UIColorHex(0x333333);
    codeField.placeholder = @"请输入验证码";
    codeField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    codeField.delegate = self;
    if (@available(iOS 12.0, *)) {
        self.codeField.textContentType = UITextContentTypeOneTimeCode;
    }
    
    [self.view addSubview:codeField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, getCodeBtn.bottom + 12, ScreenWidth - 30, 1)];
    line.backgroundColor = UIColorHex(0xf2f2f2);
    self.lineView = line;
    [self.view addSubview:line];
    
    UIButton *noGetBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 200, line.bottom, 200, 40)];
    [noGetBtn setTitle:@"获取不到验证码?" forState:UIControlStateNormal];
    [noGetBtn setTitleColor:UIColorHex(0x0060f0) forState:UIControlStateNormal];
    noGetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    noGetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noGetBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, noGetBtn.bottom + 25, ScreenWidth - 30, (ScreenWidth - 30) * 156 / 678)];
    self.loginBtn = loginBtn;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L-select"] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L-disable"] forState:UIControlStateDisabled];
    loginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    loginBtn.enabled = NO;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeAction) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.codeField becomeFirstResponder];
}


#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.lineView.backgroundColor = UIColorHex(0xf2f2f2);
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length > 0) {
        //[self.loginBtn setBackgroundColor:RGB(10, 113, 250)];
        self.loginBtn.enabled = YES;
        self.lineView.backgroundColor = UIColorHex(0x0060f0);
    } else {
        //[self.loginBtn setBackgroundColor:RGB(204, 204, 204)];
        self.loginBtn.enabled = NO;
        self.lineView.backgroundColor = UIColorHex(0xf2f2f2);
    }
}
- (void)textFieldChangeAction {
    if (self.codeField.text.length == 6) {
        [self.codeField resignFirstResponder];
    }
}

- (void)getCodeBtnDidClicked:(UIButton *)sender {
    [self sendCode];
}
- (void)sendCode {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"phone"] = self.phone;
        __weak typeof(self)weakSelf = self;
        [[UFHttpRequest defaultHttpRequest] getRequest:API_LOGIN_GETCODE alertView:nil parameters:param success:^(id  _Nullable responseObject) {
            NSDictionary *resultDic = responseObject;
    
            if ([resultDic[@"code"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"获取验证码成功"];
            }  else {
                [[JDAlertCustom currentView] alertViewWithMessage:resultDic[@"msg"]];
                _secondsAfterLastSend = 0;
                [weakSelf.getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                
                if (weakSelf.timer.isValid) {
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }
            }
        } failure:^(NSError * _Nullable error) {
            [MBProgressHUD showError:@"获取验证码失败..."];
            _secondsAfterLastSend = 0;
            [weakSelf.getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    
            if (weakSelf.timer.isValid) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
        }];
    
    [self __startSMSTimer];
}
- (void)__startSMSTimer {
    self.getCodeBtn.enabled = NO;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
        [_timer fire];
    }
}
- (void)onTick:(NSTimer *)timer {
    if (++_secondsAfterLastSend == 60) {
        _secondsAfterLastSend = 0;
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:UIColorHex(0x0060f0) forState:UIControlStateNormal];
        if (_timer.isValid) {
            [_timer invalidate];
            _timer = nil;
        }
    } else {
        NSString *time = [NSString stringWithFormat:@"%ds后重发", 60 - (int) _secondsAfterLastSend];
        [self.getCodeBtn setTitle:time forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:UIColorHex(0xb2b4be) forState:UIControlStateNormal];
    }
}

- (void)loginBtnClicked:(UIButton *)sender {
    NSString *text = [self.codeField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    __weak typeof(self)weakSelf = self;
    
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore) {//如果已经登录则登出
        [client logout:YES];
    } else {
        HError *error = [client loginWithUsername:@"username" password:@"password"];
        if (!error) { //登录成功
            [weakSelf sendRequestLogin];
        } else { //登录失败
            HError *error = [[HChatClient sharedClient] registerWithUsername:@"username" password:@"password"];
            if (!error) {//注册成功，自动登录
               HError *error =  [client loginWithUsername:@"username" password:@"password"];
                if (!error) {
                    [weakSelf sendRequestLogin];
                }
            } else {//注册失败
                NSLog(@"-----环信注册失败%@",error.errorDescription);
            }
            return;
        }
    }
    
}
- (void)sendRequestLogin {
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = self.phone;
    param[@"code"] = self.codeField.text;
    [[UFHttpRequest defaultHttpRequest] getRequest:API_USER_LOGIN alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (ISNULL(responseObject)) {
                return ;
            }
            JZUserInfo *user = [JZUserInfo mj_objectWithKeyValues:responseObject[@"data"]];
            NSArray *deviceList = responseObject[@"data"][@"devices"];
            if (deviceList.count > 0) {
                NSDictionary *device = deviceList[0];
                if (deviceList.count > 0) {
                    user.smode = [device[@"smode"] integerValue];
                    user.smodetime0 = [device[@"smodetime0"] integerValue];
                    user.smodetime1 = [device[@"smodetime1"] integerValue];
                    user.smodetime2 = [device[@"smodetime2"] integerValue];
                    user.mac = device[@"mac"];
                    user.ipaddr = device[@"ipaddr"];
                    user.port = device[@"port"];
                    user.server = device[@"server"];
                }
            }
            if (ISNULL(user.ipaddr) || [user.ipaddr isEqualToString:@""]) {
                user.ipaddr = ToothDefaultIP;
            }
            if (ISNULL(user.port) || [user.port isEqualToString:@""]) {
                user.port = [NSString stringWithFormat:@"%d",ToothDefaultPort];
            }
            [JZUserInfo archiveObject:user];
            [weakSelf loginSuccess];
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)loginSuccess {
    //登录接口
    QXMainViewController *mainVC = [[QXMainViewController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = mainVC;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
