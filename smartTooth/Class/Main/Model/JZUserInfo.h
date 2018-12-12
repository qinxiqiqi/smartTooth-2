//
//  JZUserInfo.h
//  JiangDiet
//
//  Created by zhuanghua on 2018/2/5.
//  Copyright © 2018年 JiuZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZUserInfo : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *wifiPassword;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *personalized;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *ipaddr;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *mac;
/** 当前清洁模式*/
@property (nonatomic, assign) NSInteger smode;

/** 是否绑定牙刷:0-清洁 1-美白 2-护理*/
@property (nonatomic, assign) NSInteger isBinding;
/** 对应模式的三个时长 秒/30*/
@property (nonatomic, assign) NSInteger smodetime0;
@property (nonatomic, assign) NSInteger smodetime1;
@property (nonatomic, assign) NSInteger smodetime2;

@property (nonatomic, assign) BOOL is_doctor;

#pragma mark 归档模型对象
+(void)archiveObject:(JZUserInfo *)user;

#pragma mark 读取模型对象
+(JZUserInfo *)unarchiveObject;

+(JZUserInfo *)Share;

@end


/*
 1. 更新某个值
 NSString* icon = @"http://www.116.com.cn";
 UFUserInfo* userInfo = [UFUserInfo unarchiveObject];
 userInfo.User_icon = content;
 [UFUserInfo archiveObject:userInfo];
 
 
 2.判断是否登录
 UFUserInfo *userinfo = [UFUserInfo unarchiveObject];
 NSString *userId = @"";
 if (ISNULL(userinfo))
 {
    //未登录
 }
 else
 {
    //登录
 }
 
 
 3.切换账号 或者退出登录
 [UFUserInfo archiveObject:nil];  //置空数据
 UFUserInfo* userInfo = [UFUserInfo unarchiveObject];
 if (!ISNULL(userinfo)) //检测数据是否置空
 {
 //
 
 }
 */
