//
//  ToothManager.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite/HyphenateLite.h>

@class ToothManager,QXWifiModel;

typedef NS_ENUM(NSInteger,UDPSocketReceiveType){
    UDPSocketReceiveTypeDidSendData,//已发送信息
    UDPSocketReceiveTypeNoSendData,//未发送信息
    UDPSocketReceiveTypeDidConnect,//已连接
    UDPSocketReceiveTypeNoConnect,//未连接
    UDPSocketReceiveTypeClose,//关闭
    UDPSocketReceiveTypeDidReceiveData,//接收到数据
};


@protocol ToothManagerDelegate <NSObject>
@optional
/**
 *  通过牙刷获取到wifi列表
 */
- (void)toothManager:(ToothManager *)manager getWifiList:(NSArray *)wifiList;
/**
 *  接收数据
 */
- (void)haveReceiveType:(UDPSocketReceiveType)type data:(id)data;
@end

@interface ToothManager : NSObject
@property (nonatomic, weak) id<ToothManagerDelegate>delegate;
+ (instancetype)shareManager;
//TCP
/** 是否正在绑定牙刷*/
@property (nonatomic, assign) BOOL isBindingTooth;

@property (nonatomic, strong) NSArray *wifiList;

/**
 * 初始化TCP
 */
- (void)initTcpSocketWithIpaaddr:(NSString *)ipaddr port:(NSInteger)port;
/**
 * 发送wifi信息给牙刷
 */
- (void)sendWifiInfo:(QXWifiModel *)wifi password:(NSString *)password;

- (void)sendText:(NSString *)text;

/**
 *  初始化UDP
 */
- (void)initUdpSocket;
/**
 *  断开TCP
 */
- (void)disConnectTcpSocket;
/**
 *  断开UDP
 */
- (void)disConnectUdpSocket;

/**
 * 发送udp广播
 */
- (void)sendUdpData:(NSString *)text;
/** 登陆环信*/
+ (void)loginEMChatWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *userName))success failture:(void(^)(EMError *error))failture;
/** 注册环信*/
+ (void)registerEMChatWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *userName))success failture:(void(^)(EMError *error))failture;
/** 退出当前环信账号*/
+ (void)loginOutEMChatSuccess:(void(^)(void))success failture:(void(^)(HError *error))failture;

/** 获取可用城市列表*/
@property (nonatomic, strong) NSArray *cityList;
- (void)getCityList;

/** 更新牙刷的信息*/
- (void)updateToothInfo:(NSMutableDictionary *)dict success:(void(^)(void))success;

- (void)updateUserInfo:(NSMutableDictionary *)dict;
@end
