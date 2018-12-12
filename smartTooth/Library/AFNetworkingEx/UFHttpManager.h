//
//  UFHttpManager.h
//  AFNetworking
//
//  Created by ufashion_zhangkehua on 2017/5/31.
//  Copyright © 2017年 ufashion. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface UFHttpManager : NSObject

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

+(AFHTTPSessionManager *)shardManager;

+(BOOL)isConnectionAvailable;
+(void)RemoveAllRequest;
+(void)removeTopRequest;

-(void)addTokenToRequest;

-(void)getNetworkingState:(void(^)(BOOL connectStatus , NSString* network ))connectStatus;
//+(void)changeLoginInOutRequest:(BOOL)isLogin;
//+(id)getResponseCookies;

+(void)hudAlertShow:(NSString*)str;
-(void)hudRequestShow:(UIView*)backView;
-(void)hudRequestHide:(UIView*)backView;

@end
