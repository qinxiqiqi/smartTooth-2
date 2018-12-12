//
//  UFHttpManager.m
//  AFNetworking
//
//  Created by ufashion_zhangkehua on 2017/5/31.
//  Copyright © 2017年 ufashion. All rights reserved.
//

#import "UFHttpManager.h"

static AFHTTPSessionManager *sessionManager =nil;

@implementation UFHttpManager

//创建afnetwork的单例
+(AFHTTPSessionManager *)shardManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sessionManager=[AFHTTPSessionManager manager];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",
                                                       @"text/json",
                                                       @"text/html",
                                                       @"image/jpeg",
                                                       @"image/png",
                                                       @"application/octet-stream",
                                                       @"text/xml",
                                                       @"application/x-www-form-urlencoded",
                                                       @"text/javascript",
                                                       nil];
        

        [sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
        sessionManager.securityPolicy.validatesDomainName = NO;
        
        sessionManager.requestSerializer.timeoutInterval=10;//超时
//        [sessionManager.requestSerializer setValue:AppId forHTTPHeaderField:@"appId"];
//        [sessionManager.requestSerializer setValue:@"appStore" forHTTPHeaderField:@"channel"];
        
    });
    return sessionManager;
}

#pragma mark 请求头设置
-(void)addTokenToRequest
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString* token = [defaults stringForKey:@"serverToken"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:EffectiveToken];
//    NSString* timeStamp = [NSString stringWithFormat:@"%@",[CTDate getTokenDateOfCurrent]];
//    NSString *devieceid = [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_ID];
    
    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
//    [sessionManager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"timestamp"];
    [sessionManager.requestSerializer setValue:@"appStore" forHTTPHeaderField:@"channel"];
//    [sessionManager.requestSerializer setValue:devieceid forHTTPHeaderField:@"sequence"];
    
//    LRLog(@"HTTPRequestHeaders --->  %@",[sessionManager.requestSerializer HTTPRequestHeaders]);
}

//-------------------------------------------------------------------------------------------------------------
//+(id)getResponseCookies
//{
//    NSSet *contentSet =  [sessionManager.responseSerializer acceptableContentTypes];
//    return contentSet;
//}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"igoda" ofType:@"cer"];//证书的路径
    //
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    if (ISNULL(certData)) {
    //        return nil;
    //    }
    
    //    AFSSLPinningModeNone,
    //    AFSSLPinningModePublicKey,
    //    AFSSLPinningModeCertificate, 使用证书验证模式
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    
    //如置为NO，建议自己添加对应域名的校验逻辑。
    
    securityPolicy.validatesDomainName = NO;
    
    //    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

//-(id)init
//{
//    if (self = [super init])
//    {
//
//        self.Mainqueue = [[NSOperationQueue alloc] init];
//
//    }
//    return self;
//}

//-------------------------------------------------------------------------------------------------------------
#pragma mark 取消所有请求

+(void)RemoveAllRequest
{
    NSArray *dataTasks =[UFHttpManager shardManager].tasks;
    for(NSURLSessionTask* dataTask in dataTasks)
    {
        [dataTask cancel];
    }
}

#pragma mark 取消最后一个请求

+(void)removeTopRequest
{
    NSURLSessionTask *dataTask =(NSURLSessionTask*)[UFHttpManager shardManager].tasks.lastObject;
    [dataTask cancel];
}

#pragma mark 网络是否连接

+(BOOL)isConnectionAvailable
{
    return [[[UFHttpManager alloc]init] reachabilityConnection ];
}


-(BOOL)reachabilityConnection
{
    __block  BOOL isExistenceNetwork=YES;//参数不行，用最上面的宏
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.reachabilityManager = [AFNetworkReachabilityManager manager];
    
    [self.reachabilityManager  setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //        LRLog(@"AFNetworkReachabilitystatus = %ld",(long)status);
        
        if (status==-1) {
            isExistenceNetwork=NO;
        }
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未知
            {
                isExistenceNetwork=NO;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable://无连接
            {
                isExistenceNetwork=NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://3G
            {
                isExistenceNetwork=YES;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://局域网
            {
                isExistenceNetwork=YES;
            }
                break;
            default:
                break;
        }
        
    }];
    [self.reachabilityManager startMonitoring];
    return isExistenceNetwork;
}

//可以实时获取

-(void)getNetworkingState:(void(^)(BOOL connectStatus , NSString* network ))connectStatus
{
    //    __weak typeof (self)weakself = self;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.reachabilityManager = [AFNetworkReachabilityManager manager];
    
    [self.reachabilityManager startMonitoring];
    
    
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                if(connectStatus)
                {
                    connectStatus(NO,nil);
                }
                // NSLog()
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                if(connectStatus)
                {
                    connectStatus(YES,@"wifi");
                }
                // NSLog()
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if(connectStatus)
                {
                    connectStatus(YES,@"wwan");
                }
                // NSLog()
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                if(connectStatus)
                {
                    connectStatus(NO,nil);
                }
                // NSLog()
            }
                break;
            default:
                break;
        }
    }];
}


@end








