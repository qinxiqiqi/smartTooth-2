//
//  QXLoginController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXLoginController.h"
#import "QXMainViewController.h"
#import "NSString+Verification.h"
#import "QXCertifyCodeController.h"
#import "QXWebViewController.h"
@interface QXLoginController ()<UITextFieldDelegate>
@property (nonatomic, weak) UITextField *phoneField;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation QXLoginController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 242/2, 75, 242, 57)];
    logoImgView.image = [UIImage imageNamed:@"login_pic"];
    [self.view addSubview:logoImgView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, logoImgView.bottom + 60, 64, 50)];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:18];
    phoneLabel.textColor = UIColorHex(0x979797);
    [self.view addSubview:phoneLabel];
    
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, ScreenWidth - 30 - phoneLabel.width, phoneLabel.height)];
    self.phoneField = phoneField;
    phoneField.font = [UIFont systemFontOfSize:18];
    phoneField.textColor = UIColorHex(0x333333);
    phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColorHex(0xd2d5df)}];
    phoneField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    phoneField.delegate = self;
    [self.view addSubview:phoneField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeAction) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, phoneLabel.bottom, ScreenWidth - 30, 1)];
    self.lineView = bottomLine;
    bottomLine.backgroundColor = UIColorHex(0xf2f2f2);
    [self.view addSubview:bottomLine];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, bottomLine.bottom + 60, ScreenWidth - 30, (ScreenWidth - 30) * 156 / 678)];
    self.loginBtn = loginBtn;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L-select"] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"BTN-L-disable"] forState:UIControlStateDisabled];
    loginBtn.enabled = NO;
    loginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - 17, ScreenWidth, 17)];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"点击登录表示您同意"];
    attribute.font = [UIFont systemFontOfSize:12];
    attribute.color = UIColorHex(0x979797);
    attribute.lineBreakMode = NSLineBreakByCharWrapping;
    NSAttributedString *aggrementAttri = [[NSAttributedString alloc] initWithString:@"《软件许可及服务协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorHex(0x3594ff)}];
    [attribute appendAttributedString:aggrementAttri];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(ScreenWidth, 9999)];
    container.maximumNumberOfRows = 1;
    label.textLayout = [YYTextLayout layoutWithContainer:container text:attribute];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        QXWebViewController *webVC = [[QXWebViewController alloc] init];
        webVC.requestUrl = @"http://www.baidu.com";
        webVC.navigationItem.title = @"《软件许可及服务协议》";
        [self.navigationController pushViewController:webVC animated:YES];
    };
}
- (void)loginBtnClicked:(UIButton *)sender {
    if ([self.phoneField.text isEqualToString:@""]) {
        [[JDAlertCustom currentView] alertViewWithMessage:@"手机号码不能为空"];
        return;
    }
    NSString *text = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![text validatePhoneNumber]) {
        [[JDAlertCustom currentView] alertViewWithMessage:@"手机格式不正确"];
        return;
    }
    QXCertifyCodeController *codeVC = [[QXCertifyCodeController alloc] init];
    codeVC.phone = self.phoneField.text;
    [self.navigationController pushViewController:codeVC animated:YES];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - textFieldDelegate

- (void)textFieldChangeAction {
    if (self.phoneField.text.length == 11) {
        [self.phoneField resignFirstResponder];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.lineView.backgroundColor = UIColorHex(0xf2f2f2);
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self isCanLogin]) {
        //[self.loginBtn setBackgroundColor:RGB(10, 113, 250)];
        self.loginBtn.enabled = YES;
        self.lineView.backgroundColor = UIColorHex(0x0060f0);
    } else {
        //[self.loginBtn setBackgroundColor:RGB(204, 204, 204)];
        self.loginBtn.enabled = NO;
        self.lineView.backgroundColor = UIColorHex(0xf2f2f2);
    }
}


- (BOOL)isCanLogin {
    NSString *text = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text validatePhoneNumber]) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
