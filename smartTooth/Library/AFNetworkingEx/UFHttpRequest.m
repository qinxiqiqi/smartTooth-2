//
//  UFHttpRequest.m
//  AFNetworking
//
//  Created by ufashion_zhangkehua on 2017/5/31.
//  Copyright © 2017年 ufashion. All rights reserved.
//

#import "UFHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
//#import "UFAesSecurity.h"


static UFHttpRequest *httprequest =nil;

@implementation UFHttpRequest

+(UFHttpRequest*)defaultHttpRequest
{
    if (httprequest == nil) {
        
        static dispatch_once_t once_t;
        dispatch_once(&once_t, ^{
            
            httprequest = [[self alloc] init];
        }) ;
    }
    return httprequest;
}

//post 1

-(void)postRequest:(NSString*)requestUrl  alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
     [UFHttpRequest shardManager];
     [self  addTokenToRequest];
    
//     NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,requestUrl];
     [[UFHttpRequest shardManager]POST:requestUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
         
         if (responseObject != nil) {
             
             NSString* msg = responseObject[@"msg"];
             if ( msg != nil && [msg isEqualToString:@"无效token"])
             {
//                 [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (![error.localizedDescription isEqualToString:@"cancelled"])
         {
             if (failure)
             {
                 failure(error);
             }
         }
     }];
}

//post 2

-(void)postRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    [UFHttpRequest shardManager];
    [self  addTokenToRequest];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,targetUrl];
    
//    LRLog(@"urlStr=%@",urlStr);

    [[UFHttpRequest shardManager]POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
         
         if (responseObject != nil) {
             
             NSString* msg = responseObject[@"msg"];
             if ( msg != nil && [msg isEqualToString:@"无效token"])
             {
//                 [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
             }
         }

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (![error.localizedDescription isEqualToString:@"cancelled"])
         {
             if (failure)
             {
                 failure(error);
             }
         }
     }];

}

//Post 上传图片1
-(void)postRequest:(NSString*)requestUrl  alertView:(UIView*)destView parameters:(id)parameters formatData:(NSData*)imageData fileName:(NSString*)fileName success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    
     [UFHttpRequest shardManager];
     [self  addTokenToRequest];
    
//    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,requestUrl];
    [[UFHttpRequest shardManager]POST:requestUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        if (imageData != nil&& [imageData isKindOfClass:[NSData class]]) {
        
        if(imageData){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *filename = [NSString stringWithFormat:@"%@.png", str];
            //上传的参数(上传图片，以文件流的格式)
           
            [formData appendPartWithFileData:imageData
                                        name:fileName
                                    fileName:filename
                                    mimeType:@"image/png"];
        }
//        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success)
        {
            success(responseObject);
        }
        
        if (responseObject != nil) {
            
            NSString* msg = responseObject[@"msg"];
            if ( msg != nil && [msg isEqualToString:@"无效token"])
            {
//                [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![error.localizedDescription isEqualToString:@"cancelled"])
        {
            if (failure)
            {
                failure(error);
            }
        }
    }];
}

//Post 上传图片1

-(void)postRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView parameters:(id)parameters formatData:(NSData*)imageData fileName:(NSString*)fileName success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    //    [self getNetworkingState:^(bool connectStatus) {
    //        if (!connectStatus)
    //        {
    //        [self showError:@"无网络" toView:destView];
    //        return;
    //        }
    //        
    //    }];
    
    [UFHttpRequest shardManager];
    [self  addTokenToRequest];

//    __weak typeof(self)weakSelf = self;
//    [self showMsg:@"上传中..." toView:destView];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,targetUrl];
    
    [[UFHttpRequest shardManager]POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageData != nil&& [imageData isKindOfClass:[NSData class]]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [weakSelf hidHud:destView];
        
        if (success)
        {
            success(responseObject);
        }
        
        if (responseObject != nil) {
            
            NSString* msg = responseObject[@"msg"];
            if ( msg != nil && [msg isEqualToString:@"无效token"])
            {
//                [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [weakself hidHud:destView];
        
        if (![error.localizedDescription isEqualToString:@"cancelled"])
        {
            if (failure)
            {
                failure(error);
            }
        }
    }];
}

//get1
-(void)getRequest:(NSString*)requestUrl  alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
//    __block typeof (self)weakself = self;
//    [weakself showActivitytoView:destView];
    
    //[UFHttpRequest shardManager];
    //[self  addTokenToRequest];
    
//    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,requestUrl];
    
//     LRLog(@"URL=%@",urlStr);
    
    [[UFHttpRequest shardManager]GET:requestUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [weakself hidHud:destView];
        if (success)
        {
            success(responseObject);
        }
        
        if (responseObject != nil) {
            
            NSString* msg = responseObject[@"msg"];
            if ( msg != nil && [msg isEqualToString:@"无效token"])
            {
//                [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [weakself hidHud:destView];
        if (![error.localizedDescription isEqualToString:@"cancelled"])
        {
            if (failure)
            {
                failure(error);
            }
        }
    }];
}

//get2   targetUrl在使用中需要添加参数
-(void)getRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    [UFHttpRequest shardManager];
    [self  addTokenToRequest];
//    __block typeof (self)weakself = self;
//    [weakself showActivitytoView:destView];
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,targetUrl];
    
    [[UFHttpRequest shardManager]GET:requestUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         [weakself hidHud:destView];
         if (success)
         {
            success(responseObject);
         }
        
        if (responseObject != nil) {
            
            NSString* msg = responseObject[@"msg"];
            if ( msg != nil && [msg isEqualToString:@"无效token"])
            {
//                [[UFAesSecurity getUFAesSecurity]getTokenFromServer];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [weakself hidHud:destView];
        if (![error.localizedDescription isEqualToString:@"cancelled"])
        {
            if (failure)
            {
                failure(error);
            }
        }
    }];
}


-(void)downLoadRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView  fileName:(NSString*)fileName progress:(void(^)(NSProgress * _Nonnull downloadProgress))progress resultState:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSString * _Nullable filename, NSError * _Nullable error))resultState
{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:targetUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[UFHttpRequest shardManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //NSLog(@"filePath=%@",documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //NSLog(@"%@--%@",response,filePath);
        if (resultState) {
            resultState(response,filePath,fileName,error);
        }
    }] resume];
}

//下载故事
-(void)downLoadStoryRequest:(NSString*)baseUrl targetUrl:(NSString*)targetUrl alertView:(UIView*)destView  fileContent:(NSDictionary*)fileDic progress:(void(^)(NSProgress * _Nonnull downloadProgress))progress resultState:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSDictionary * _Nullable fileDic, NSError * _Nullable error))resultState
{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:targetUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[UFHttpRequest shardManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //        NSLog(@"filePath=%@",documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //NSLog(@"%@--%@",response,filePath);
        if (resultState) {
            resultState(response,filePath,fileDic,error);
        }
    }] resume];
}



/*** activity ***/
#pragma --mark activity start

//无蒙版
-(void)showActivitytoView:(UIView*)destView
{
    if (destView != nil && [destView isKindOfClass:[UIView class]])
    {
//        [MBProgressHUD showActivitytoView:destView];
    }
}

//蒙版
-(void)showMsg:(NSString*)msg toView:(UIView*)destView
{
    if (destView != nil && [destView isKindOfClass:[UIView class]])
    {
//        [MBProgressHUD showMessag:msg toView:destView];
    }
}

-(void)hidHud:(UIView*)destView
{
    if (destView != nil && [destView isKindOfClass:[UIView class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:destView animated:YES];
            
        });
    }
}


-(void)showSuccess:(NSString*)msg toView:(UIView*)destView
{
    if (destView != nil && [destView isKindOfClass:[UIView class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [MBProgressHUD showSuccess:msg toView:destView];
        });
    }
}

-(void)showError:(NSString*)msg toView:(UIView*)destView
{
    if (destView != nil && [destView isKindOfClass:[UIView class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [MBProgressHUD showError:msg toView:destView];
            
        });
    }
}


#pragma --mark activity end

/*****************************************************************************************/


//+(void)alertForRequest:(UIView*)backview
//{
//    if((backview)){
//        return;
//    }
//    
//    MBProgressHUD*  HUD = [[MBProgressHUD alloc]initWithView:backview];
//    [backview addSubview:HUD];
//    //    HUD.dimBackground = YES;
//    /*    UIImageView *imaged = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadgif1"]];
//     NSMutableArray *arr = [NSMutableArray array];
//     for (int i=0; i<11; i++) {
//     [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadgif%d@2x.png",(i+1)]]];
//     }
//     //设置动画数组
//     [imaged setAnimationImages:arr];
//     //设置动画播放次数
//     //    [imaged setAnimationRepeatCount:1];
//     //设置动画播放时间
//     [imaged setAnimationDuration:11*0.075];
//     //开始动画
//     [imaged startAnimating];
//     
//     
//     HUD.customView = imaged;
//     HUD.color = [UIColor clearColor];
//     HUD.mode = MBProgressHUDModeCustomView;
//     */
//    //    HUD.labelText = @"当前网络不可用，请稍后再试";
//
//    [HUD showAnimated:YES];
//    //    [HUD hide:YES afterDelay:2];
//}

#pragma mark json


//-(void)alertForRequest:(UIView*)backview
//{
//    if((backview)){
//        return;
//    }
//    MBProgressHUD*  HUD = [[MBProgressHUD alloc]initWithView:backview];
//    [backview addSubview:HUD];
//    //    HUD.dimBackground = YES;
//    /*    UIImageView *imaged = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadgif1"]];
//     NSMutableArray *arr = [NSMutableArray array];
//     for (int i=0; i<11; i++) {
//     [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadgif%d@2x.png",(i+1)]]];
//     }
//     //设置动画数组
//     [imaged setAnimationImages:arr];
//     //设置动画播放次数
//     //    [imaged setAnimationRepeatCount:1];
//     //设置动画播放时间
//     [imaged setAnimationDuration:11*0.075];
//     //开始动画
//     [imaged startAnimating];
//     
//     
//     HUD.customView = imaged;
//     HUD.color = [UIColor clearColor];
//     HUD.mode = MBProgressHUDModeCustomView;
//     //    HUD.labelText = @"当前网络不可用，请稍后再试";
//     */
//    HUD.mode = MBProgressHUDAnimationFade;
//    //    HUD.removeFromSuperViewOnHide = YES;
//    [HUD showAnimated:YES];
//    //    [HUD hide:YES afterDelay:2];
//}


//-(void)ShowALert
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确保您的网络已连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//}


@end


