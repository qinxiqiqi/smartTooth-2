//
//  ToothManager.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "ToothManager.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"
//获取手机信息
#import <ifaddrs.h>
#import <arpa/inet.h>

#import "QXWifiModel.h"
#import "CityModel.h"
#import <HelpDesk/HelpDesk.h>
@interface ToothManager()<GCDAsyncUdpSocketDelegate,GCDAsyncSocketDelegate>
{
    u_int16_t _aAppPort;//手机 port
    NSString *_AppIpStr;//手机 ip
    long msgTag;//记录接收到的信息的 tag 值
    NSTimer *_sendTimer;//定时器,用于多次发送广播
    int _timerCount;//记录定时器发送次数
    NSString *_aDevIpStr;//硬件设备 ip
    u_int16_t _aDevPort;//硬件设备 port
    id context;
}
@property (nonatomic, strong) GCDAsyncUdpSocket *gcdUdpSocket;
@property (nonatomic, strong) GCDAsyncSocket *tcpSocket;
@end

@implementation ToothManager

+ (instancetype)shareManager
{
    static ToothManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ToothManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self adjustNetState];
    }
    return self;
}
- (void)adjustNetState {
    [[UFHttpRequest defaultHttpRequest] getNetworkingState:^(BOOL connectStatus, NSString *network){
        
        if (connectStatus) {
            if ([network isEqualToString:@"wifi"]) {
                [self initUdpSocket];
            }
        }
        else{
            
            [self.gcdUdpSocket close];
        }
    }];
}


#pragma mark - TCP
- (void)initTcpSocketWithIpaaddr:(NSString *)ipaddr port:(NSInteger)port
{
    //[MBProgressHUD showMessage:@"连接中..."];
    self.tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError *error;
    [self.tcpSocket connectToHost:ipaddr onPort:port withTimeout:12 error:&error];
    if (error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD showError:error.localizedFailureReason];
//        });
    }
}
- (void)sendWifiInfo:(QXWifiModel *)wifi password:(NSString *)password
{
    NSError *error;
    [_gcdUdpSocket beginReceiving:&error];
    
    self.isBindingTooth = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"ssid"] = wifi.SSID;
    NSArray *array = [wifi.Security componentsSeparatedByString:@"/"];
    if (array.count > 1) {
        dict[@"encrytype"] = array[1];
    }
    NSString *authmode = array[0];
    if (ISNULL(authmode) || [authmode isEqualToString:@"NULL"]) {
        dict[@"authmode"] = @"NONE";
    } else {
        dict[@"authmode"] = @"WPA2PSK";
    }
    dict[@"password"] = password;
    dict[@"channel"] = wifi.Channel;
    dict[@"tcpaddr"] = @"jumodel.cn";
    dict[@"tcpport"] = @"8888";
    NSData *data= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [self.tcpSocket writeData:data withTimeout:10 tag:1000];
}
- (void)sendText:(NSString *)text
{
    [self.tcpSocket writeData:[text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"TCP链接成功"];
    });
    //设置客户端处于接收数据的状态
    [self.tcpSocket readDataWithTimeout:-1 tag:0];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
   
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (ISNULL(dict)) {
        return;
    }
    
    if ([dict[@"status"] isEqualToString:@"OK"]) {//配网获取的wifi列表
        self.wifiList = [QXWifiModel mj_objectArrayWithKeyValuesArray:dict[@"wifiList"]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(toothManager:getWifiList:)]) {
            [self.delegate toothManager:self getWifiList:self.wifiList];
        }
    }
    
}

//接收视频
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
    
}


#pragma mark - UDP
- (void)initUdpSocket
{
    if (!_gcdUdpSocket) {
        GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        self.gcdUdpSocket = socket;
    }
    NSError *error = nil;
    
    [_gcdUdpSocket bindToPort:10020 error:&error];
    
    if (error) {//监听错误打印错误信息
        NSLog(@"error1:%@",error);
        return;
    }else {//监听成功则开始接收信息
        [_gcdUdpSocket beginReceiving:&error];
    }
    
    //启用广播
    [_gcdUdpSocket enableBroadcast:YES error:&error];
    
    if (error) {
        NSLog(@"error2:%@",error);
        return;
    }
    
    //开始接收数据(不然会收不到数据)
    [_gcdUdpSocket beginReceiving:&error];
    
    if (error) {
        NSLog(@"error3:%@",error);
        return;
    }
}

- (void)sendUdpData:(NSString *)text;
{
    NSString *port = @"5060";//端口
    //定时发送 3 次广播, 接受所有返回数据的设备数据
    _timerCount = 0;

    NSDictionary *infoDic = @{@"sendData":[text dataUsingEncoding:NSUTF8StringEncoding], @"finalStr":ToothDefaultIP, @"port":port};
    _sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(sendBroadcast:) userInfo:infoDic repeats:YES];
}
- (void)sendBroadcast:(NSTimer *)aTimer {
    
    NSDictionary *dic = aTimer.userInfo;
    
    _timerCount += 1;
    if (_timerCount == 3) {
        [_sendTimer invalidate];
        _sendTimer = nil;
    }else if (_timerCount < 3){
        //
        [self.gcdUdpSocket sendData:[dic objectForKey:@"sendData"] toHost:[dic objectForKey:@"finalStr"] port:[[dic objectForKey:@"port"] integerValue] withTimeout:1000 tag:0];
    }
}
#pragma mark - 获取当前手机 IP
- (NSString *)getIPAddress {
    NSString *address = @"error";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    msgTag = tag;//记录发送消息的 tag
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
        [self.delegate haveReceiveType:UDPSocketReceiveTypeDidSendData data:@(tag)];
    }
    
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
        [self.delegate haveReceiveType:UDPSocketReceiveTypeNoSendData data:error];
    }
   
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
       [self.delegate haveReceiveType:UDPSocketReceiveTypeDidConnect data:address];
    }
    
    NSLog(@"didConnectToAddress");
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
       [self.delegate haveReceiveType:UDPSocketReceiveTypeNoConnect data:error];
    }
    
}
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
       [self.delegate haveReceiveType:UDPSocketReceiveTypeClose data:error];
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSLog(@"didReceiveData");
    
    //[self.gcdUdpSocket beginReceiving:nil];
    
    //
    //NSString *host = [GCDAsyncUdpSocket hostFromAddress:address];
    //uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (!ISNULL(receiveDic[@"ipaddr"])) {
        user.ipaddr = receiveDic[@"ipaddr"];
    }
    if (!ISNULL(receiveDic[@"port"])) {
        user.port = receiveDic[@"port"];
    }
    if (!ISNULL(receiveDic[@"server"])) {
        user.server = receiveDic[@"server"];
    }
    if (!ISNULL(receiveDic[@"mac"])) {
        user.mac = receiveDic[@"mac"];
        user.isBinding = 1;
    }
    [JZUserInfo archiveObject:user];
    
    if (_delegate && [_delegate respondsToSelector:@selector(haveReceiveType:data:)]) {
        //[self.gcdUdpSocket close];//关闭udp连接
        [self.delegate haveReceiveType:UDPSocketReceiveTypeDidReceiveData data:receiveDic];
    }
}
- (void)disConnectTcpSocket
{
    [self.tcpSocket disconnect];//关闭tcp连接
}
- (void)disConnectUdpSocket
{
    [self.gcdUdpSocket close];//关闭udp连接
}


#pragma mark - 环信
//登陆
+ (void)loginEMChatWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(NSString *))success failture:(void (^)(EMError *))failture
{
    [[EMClient sharedClient] loginWithUsername:userName password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            //设置是否自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            success(aUsername);
        } else {
            failture(aError);
        }
    }];
}

//注册
+ (void)registerEMChatWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(NSString *))success failture:(void (^)(EMError *))failture
{
    [[EMClient sharedClient] registerWithUsername:userName password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            success(aUsername);
        } else {
            failture(aError);
        }
    }];
}

//退出当前环信账号
+ (void)loginOutEMChatSuccess:(void (^)(void))success failture:(void (^)(HError *))failture
{
    HError *error = [[HChatClient sharedClient] logout:YES];
    if (error) { //登出出错
        if (failture) {
            failture(error);
        }
    } else {//登出成功
        if (success) {
            success();
        }
    }
}



- (void)getCityList
{
    [[UFHttpRequest defaultHttpRequest] postRequest:API_LOCATION_CITYLIST alertView:nil parameters:nil success:^(id  _Nullable responseObject) {
        if (ISNULL(responseObject)) {
            return ;
        }
        NSDictionary *data = responseObject[@"data"];
        if (ISNULL(data)) {
            return;
        }
        self.cityList = [CityModel mj_objectArrayWithKeyValuesArray:data[@"area"]];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}


- (void)updateToothInfo:(NSMutableDictionary *)dict success:(void (^)(void))success
{
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    dict[@"mac"] = user.mac;
    dict[@"uid"] = user.userId;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_TOOTH_UPDATE alertView:nil parameters:dict success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (success) {
                success();
            }
        }
    } failure:^(NSError * _Nullable error) {
       
    }];
}

- (void)updateUserInfo:(NSMutableDictionary *)dict
{
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    dict[@"uid"] = user.userId;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_USER_UPDATE alertView:nil parameters:dict success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
        } else {
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
