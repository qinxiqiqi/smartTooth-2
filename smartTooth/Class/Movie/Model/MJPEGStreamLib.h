//
//  MJPEGStreamLib.h
//  smartTooth
//
//  Created by qinxi on 2018/11/14.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StreamStatus){
    StreamStatusStop,
    StreamStatusLoading,
    StreamStatusPlay
};

@interface MJPEGStreamLib : NSObject<NSURLSessionDataDelegate>
@property (nonatomic, assign) StreamStatus status;
@property (nonatomic, copy) void(^didStartLoding)();
@property (nonatomic, copy) void(^didFinishLoding)();

- (instancetype)initImageView:(UIImageView *)imageView contentURL:(NSString *)url;
- (void)play;
- (void)stop;
@end

