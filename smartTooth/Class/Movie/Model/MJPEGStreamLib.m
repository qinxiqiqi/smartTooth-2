//
//  MJPEGStreamLib.m
//  smartTooth
//
//  Created by qinxi on 2018/11/14.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "MJPEGStreamLib.h"

@interface MJPEGStreamLib()
{
    NSURLSessionDataTask *dataTask;
    NSURLSession *session;
}
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *contentUrl;
@end
@implementation MJPEGStreamLib

- (instancetype)initImageView:(UIImageView *)imageView contentURL:(NSString *)url
{
    self = [super init];
    if (self) {
        self.imageView = imageView;
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.contentUrl = url;
        
    }
    return self;
}

- (void)play
{
    self.status = StreamStatusLoading;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.didStartLoding) {
            self.didStartLoding();
        }
    });
    
    self.receivedData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.contentUrl]];
    dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)stop {
    self.status = StreamStatusStop;
    [dataTask cancel];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSData *data = self.receivedData;
    if (data.length > 0) {
        UIImage *receivedImage = [UIImage  imageWithData:data];
        if (self.status == StreamStatusLoading) {
            self.status = StreamStatusPlay;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.didFinishLoding) {
                    self.didFinishLoding();
                }
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = receivedImage;
        });
    }
    _receivedData = [NSMutableData data];
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSURLCredential *credential;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        disposition = NSURLSessionAuthChallengeUseCredential;
    } else {
        
    }
    completionHandler(disposition,credential);
}

-(void)dealloc
{
    [dataTask cancel];
}
@end
