//
//  UFHttpRequest.h
//  AFNetworking
//
//  Created by ufashion_zhangkehua on 2017/5/31.
//  Copyright © 2017年 ufashion. All rights reserved.
//


#import "UFHttpManager.h"

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

#define isConnecting   ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0 ? YES : NO)


typedef void (^ResponeBlock)(id _Nullable Qresponse);
typedef void (^NetBlock)();
static BOOL httpRequestCount = YES;


@interface UFHttpRequest : UFHttpManager

+(UFHttpRequest*_Nullable)defaultHttpRequest;

//post
-(void)postRequest:(NSString*_Nonnull)requestUrl  alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;


-(void)postRequest:(NSString*_Nonnull)baseUrl targetUrl:(NSString*_Nonnull)targetUrl alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;


-(void)postRequest:(NSString*_Nonnull)requestUrl  alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters formatData:(NSData*_Nullable)imageData fileName:(NSString*_Nullable)fileName success:(void(^_Nullable)(id _Nullable responseObject))success failure:(void(^_Nullable)(NSError * _Nullable error))failure;


-(void)postRequest:(NSString*_Nonnull)baseUrl targetUrl:(NSString*_Nonnull)targetUrl alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters formatData:(NSData*_Nullable)imageData fileName:(NSString*_Nullable)fileName success:(void(^_Nullable)(id _Nullable responseObject))success failure:(void(^_Nullable)(NSError * _Nullable error))failure;


//get1
-(void)getRequest:(NSString*_Nonnull)requestUrl  alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;


//get2
-(void)getRequest:(NSString*_Nonnull)baseUrl targetUrl:(NSString*_Nonnull)targetUrl alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;


-(void)downLoadRequest:(NSString*_Nullable)baseUr_Nullablel targetUrl:(NSString*_Nullable)targetUrl alertView:(UIView*_Nullable)destView  fileName:(NSString*_Nullable)fileName progress:(void(^_Nullable)(NSProgress * _Nonnull downloadProgress))progress resultState:(void (^_Nullable)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSString * _Nullable filename, NSError * _Nullable error))resultState;


-(void)downLoadStoryRequest:(NSString*_Nullable)baseUrl targetUrl:(NSString*_Nullable)targetUrl alertView:(UIView*_Nullable)destView  fileContent:(NSDictionary*_Nullable)fileDic progress:(void(^_Nullable)(NSProgress * _Nonnull downloadProgress))progress resultState:(void (^_Nullable)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSDictionary * _Nullable fileDic, NSError * _Nullable error))resultState;


//put1
//-(void)putRequest:(NSString*_Nonnull)requestUrl  alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError * _Nullable error))failure;


////put2
//-(void)putRequest:(NSString*_Nonnull)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^_Nullable)(NSError *error))failure;
//
//
////Delete1
//-(void)deleteRequest:(NSString*)requestUrl  alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//
//
////Delete2
//-(void)deleteRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//
//
////
//-(void)postVideoRequest:(NSString*)requestUrl  alertView:(UIView*)destView parameters:(id)parameters formatData:(NSData*)imageData fileName:(NSString*)fileName videoUrl:(NSURL*)videoUrl  uploadProgress:(void(^_Nullable)(NSProgress * _Nonnull uploadProgress)) loadProgress success:(void(^_Nullable)(id _Nullable responseObject))success failure:(void(^_Nullable)(NSError * _Nullable error))failure;
//
//
////
//-(void)postVideoRequest:(NSString*_Nullable)requestUrl  alertView:(UIView*_Nullable)destView parameters:(id _Nullable )parameters formatData:(NSData*_Nullable)imageData fileName:(NSString*_Nullable)fileName success:(void(^_Nullable)(id _Nullable responseObject))success failure:(void(^_Nullable)(NSError * _Nullable error))failure;


@end

