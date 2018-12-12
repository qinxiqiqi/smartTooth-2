//
//  QXBindingWifiController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXBindingWifiController.h"
#import <JFGSDK/JFGSDKBindingDevice.h>
#import "ToothManager.h"
#import "QXWifiModel.h"
@interface QXBindingWifiController ()<ToothManagerDelegate>
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIButton *connectBtn;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, assign) BOOL isBindingSuccess;
@end

@implementation QXBindingWifiController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"配置设备上网";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    [ToothManager shareManager].delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)setupView {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 77, kNavigationBarHeight + 32, 154, 80)];
    imgView.image = [UIImage imageNamed:@"net_link"];
    [self.view addSubview:imgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom, ScreenWidth, 60)];
    nameLabel.text = self.wifiModel.SSID;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = UIColorHex(0x333333);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom, ScreenWidth, 60)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    CGFloat leftMargin = 30;
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, 30, whiteView.height)];
    alertLabel.textColor = UIColorHex(0x979797);
    alertLabel.font = [UIFont systemFontOfSize:14];
    alertLabel.text = @"密码";
    [whiteView addSubview:alertLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(alertLabel.right + 20, 0, whiteView.width - alertLabel.right - 20, whiteView.height)];
    self.textField = textField;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"请输入对应的Wi-Fi密码";
    [whiteView addSubview:textField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, whiteView.bottom, ScreenWidth - leftMargin * 2, 1)];
    self.lineView = lineView;
    lineView.backgroundColor = kLineColor;
    [self.view addSubview:lineView];
    
    UIButton *connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, whiteView.bottom + 30, ScreenWidth - leftMargin * 2, 40)];
    self.connectBtn = connectBtn;
    [connectBtn setTitle:@"链接" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectBtn.backgroundColor = RGB(204, 204, 204);
    connectBtn.layer.cornerRadius = connectBtn.height/2;
    connectBtn.layer.masksToBounds = YES;
    [connectBtn addTarget:self action:@selector(connectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangeAction) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)connectBtnDidClicked:(UIButton *)sender {
    if ([self.textField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入wifi密码"];
    } else {//链接
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[ToothManager shareManager] sendWifiInfo:self.wifiModel password:self.textField.text];
        [self performSelector:@selector(justIsOverTime) withObject:nil afterDelay:15];
//        [[ToothManager shareManager] sendUdpData:@"1"];
    }
}
- (void)connectUdp {
    //链接UDP
    [[ToothManager shareManager] initUdpSocket];
}
- (void)justIsOverTime {
    if (!_isBindingSuccess) {//没有绑定成功
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"链接失败，请重试！"];
        if (self.bindingOverTime) {
            self.bindingOverTime();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)haveReceiveType:(UDPSocketReceiveType)type data:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
    
    NSLog(@"----------%@",data);
    switch (type) {
        case UDPSocketReceiveTypeDidConnect:
            //[MBProgressHUD showSuccess:@"已连接"];
            break;
            
        case UDPSocketReceiveTypeNoConnect:
            //[MBProgressHUD showSuccess:@"未连接"];
            break;
            
        case UDPSocketReceiveTypeDidSendData:
            //[MBProgressHUD showSuccess:@"已发消息"];
            break;
        
        case UDPSocketReceiveTypeNoSendData:
            //[MBProgressHUD showSuccess:@"未发消息"];
            break;
            
        case UDPSocketReceiveTypeClose:
            //[MBProgressHUD showSuccess:@"已关闭"];
            break;
            
        case UDPSocketReceiveTypeDidReceiveData:
            
            [self haveReceiveData:data];
            break;
    }
}
- (void)haveReceiveData:(id)data {
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mac"] = user.mac;
    dict[@"server"] = user.server;
    dict[@"ipaddr"] = user.ipaddr;
    dict[@"port"] = user.port;
    [[ToothManager shareManager] updateToothInfo:dict success:nil];
    self.isBindingSuccess = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"配网成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

- (void)textFieldChangeAction {
    if (self.textField.text.length < 8) {
        [self.connectBtn setBackgroundColor:RGB(204, 204, 204)];
        self.lineView.backgroundColor = kLineColor;
    } else {
        [self.connectBtn setBackgroundColor:RGB(10, 113, 250)];
        self.lineView.backgroundColor = UIColorHex(0x0060f0);
    }
}



////绑定过程及成功回调
//-(void)jfgBindDeviceProgressStatus:(JFGSDKBindindProgressStatus)status
//{
//    if (status == JFGSDKBindindProgressStatusSuccess) {
//        [MBProgressHUD showSuccess:@"绑定视频设备成功"];
//
//    }
//}
//
////绑定失败
//-(void)jfgBindDeviceFailed:(int)errorCode
//{
//    [MBProgressHUD showError:@"绑定视频设备失败"];
//    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"bind-Result:fail");
//}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
