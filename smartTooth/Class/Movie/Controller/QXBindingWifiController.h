//
//  QXBindingWifiController.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXWifiModel;

@interface QXBindingWifiController : UIViewController
@property (nonatomic, strong) QXWifiModel *wifiModel;
@property (nonatomic, copy) void(^bindingOverTime)(void);
@end
