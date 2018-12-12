//
//  JZUploadImg.m
//  UploadImg
//
//  Created by Demi on 2018/6/11.
//  Copyright © 2018年 jz. All rights reserved.
//

#import "JZUploadImg.h"

#import "UFHttpRequest.h"
#import "JDAlertCustom.h"

static JZUploadImg *instance;
static QNUploadManager *QNInstance;


typedef void(^uploadToken)(NSString *uploadToken);

@interface JZUploadImg ()

//@property ( nonatomic , strong ) NSMutableDictionary *fileStateDict;

@end


@implementation JZUploadImg

//- (NSMutableDictionary *)fileStateDict{
//    if (_fileStateDict == nil) {
//        _fileStateDict = [[NSMutableDictionary alloc] init];
//    }
//    return _fileStateDict;
//}


+(QNUploadManager *)ShareUploadManager:(QNConfiguration *)Configuration{
    
    if (QNInstance == nil) {
        static dispatch_once_t once_t;
        dispatch_once(&once_t, ^{
            
            QNInstance = [[QNUploadManager alloc] initWithConfiguration:Configuration];
            
        }) ;
    }
    return QNInstance;
}

+(QNUploadManager *)ShareUploadManager{
    
    if (QNInstance == nil) {
        static dispatch_once_t once_t;
        dispatch_once(&once_t, ^{
            
            QNInstance = [[QNUploadManager alloc] init];
            
        }) ;
    }
    return QNInstance;
}

+(JZUploadImg *)ShareUploadImg
{
    if (instance == nil) {
        static dispatch_once_t once_t;
        dispatch_once(&once_t, ^{
            instance = [[self alloc] init];
        }) ;
    }
    return instance;
}


- (void)uploadFielData:(NSData *)data uploadType:(uploadWorkType)uploadType andConfiguration:(QNConfiguration *)Configuration andState:(uploadState)fileState{
    
    
    if (uploadType < 0 || uploadType > 3) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"failureDesc"] = @"请选择正确的文件格式";
        dict[@"state"] = @"-2";
        if (self.state) {
            self.state(dict);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self getUploadFielToken:^(NSString *uploadToken) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSString *token = uploadToken;

        NSMutableDictionary *fileStateDict = [[NSMutableDictionary alloc] init];
        

        QNUploadManager *manager = Configuration == nil ? [JZUploadImg ShareUploadManager] : [JZUploadImg ShareUploadManager:Configuration];
        
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//            NSLog(@" 上次进度 percent == %.2f [NSThread currentThread] %@ ", percent,[NSThread currentThread]);
            if (![NSThread isMainThread]) {
                NSLog(@"no  isMainThread");
                dispatch_async(dispatch_get_main_queue(), ^{
                    fileStateDict[@"percent"] = [NSString stringWithFormat:@"%.2f",percent];
                    fileStateDict[@"key"] = key;
                    fileStateDict[@"state"] = @"-1";

                    if (fileState) {
                        fileState(fileStateDict);
                    }
                });
            }else{
                fileStateDict[@"percent"] = [NSString stringWithFormat:@"%.2f",percent];
                fileStateDict[@"key"] = key;
                fileStateDict[@"state"] = @"-1";
                
                if (fileState) {
                    fileState(fileStateDict);
                }
            }
            
        }params:nil checkCrc:NO cancellationSignal:nil];
        
        
        [manager putData:data key:[strongSelf uuid:uploadType] token:token
                complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                 
                    if (resp != nil) {
                        fileStateDict[@"state"] = @"1";
                    }else{
                        fileStateDict[@"state"] = @"0";
                    }
                    if (fileState) {
                        fileState(fileStateDict);
                    }
                } option:uploadOption];
        
    } failure:^(NSError *error) {
//        NSLog(@"获取上传token失败");
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (error.code == -1) {
            dict[@"failureDesc"] = error.userInfo[@"ErrorMessage"];
        }else{
            dict[@"failureDesc"] = error.localizedDescription;
        }
        dict[@"state"] = @"-2";
        if (fileState) {
            fileState(dict);
        }
    }];
}

- (void)uploadFielData:(NSData *)data uploadType:(uploadWorkType)uploadType andConfiguration:(QNConfiguration *)Configuration{
    
    if (uploadType < 0 || uploadType > 3) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"failureDesc"] = @"请选择正确的文件格式";
        dict[@"state"] = @"-2";
        if (self.state) {
            self.state(dict);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self getUploadFielToken:^(NSString *uploadToken) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSString *token = uploadToken;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        QNUploadManager *manager = Configuration == nil ? [JZUploadImg ShareUploadManager] : [JZUploadImg ShareUploadManager:Configuration];
        
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//            NSLog(@" 上次进度 percent == %.2f", percent);
            
            if (![NSThread isMainThread]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    dict[@"percent"] = [NSString stringWithFormat:@"%.2f",percent];
                    dict[@"key"] = key;
                    dict[@"state"] = @"-1";
                    
                    if (self.state) {
                        self.state(dict);
                    }
                });
                
            }else{
                dict[@"percent"] = [NSString stringWithFormat:@"%.2f",percent];
                dict[@"key"] = key;
                dict[@"state"] = @"-1";
                
                if (self.state) {
                    self.state(dict);
                }
            }
        }params:nil
         checkCrc:NO
         cancellationSignal:nil];
        
        
        [manager putData:data key:[strongSelf uuid:uploadType] token:token
                                         complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                             NSLog(@"info %@", info);
                                             NSLog(@"resp %@", resp);
                                             if (resp != nil) {
                                                 NSLog(@"上传成功");
                                                 dict[@"state"] = @"1";
                                             }else{
                                                 NSLog(@"上传失败");
                                                 dict[@"state"] = @"0";
                                             }
                                             if (self.state) {
                                                 self.state(dict);
                                             }
                                         } option:uploadOption];
    
    } failure:^(NSError *error) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (error.code == -1) {
            dict[@"failureDesc"] = error.userInfo[@"ErrorMessage"];
        }else{
            dict[@"failureDesc"] = error.localizedDescription;
        }
        dict[@"state"] = @"-2";
        if (self.state) {
            self.state(dict);
        }
    }];
    
    
}


- (void)getUploadFielToken:(uploadToken)token failure:(void (^)(NSError *error))failure{
    
    [[UFHttpRequest defaultHttpRequest] getRequest:API_TOKEN_CQN alertView:nil parameters:nil success:^(id  _Nullable responseObject) {
        NSDictionary *bodyDic = responseObject;
        if ([bodyDic[@"code"] integerValue] == 0) {
            
            token(bodyDic[@"data"]);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:bodyDic[@"message"]                                                                      forKey:@"ErrorMessage"];
            NSError *error = [NSError errorWithDomain:@"获取上传token失败" code:-1 userInfo:userInfo];
            if (failure)
            {
                failure(error);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

- (NSString *)uuid:(uploadWorkType)uploadType
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"_%f", a];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    result = [result stringByAppendingString:timeString];
    NSString *suffixStr = nil;
    if (uploadType == 0) {
        suffixStr = @"";
    }else if (uploadType == 1){
        suffixStr = @".mp4";
    }else if (uploadType == 2){
        suffixStr = @".mp3";
    }else if (uploadType == 3){
        suffixStr = @".GIF";
    }
    result = [result stringByAppendingString:suffixStr];
    return result;
}

@end
