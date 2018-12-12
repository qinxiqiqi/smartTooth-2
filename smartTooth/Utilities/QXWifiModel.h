//
//  QXWifiModel.h
//  SmartTooth
//
//  Created by qinxi on 2018/10/29.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXWifiModel : NSObject
@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *Security;
@property (nonatomic, copy) NSString *Signal;
@property (nonatomic, copy) NSString *Channel;
@end

NS_ASSUME_NONNULL_END
