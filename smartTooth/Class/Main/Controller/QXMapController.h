//
//  QXMapController.h
//  SmartTooth
//
//  Created by qinxi on 2018/11/2.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QXClinicModel;

@interface QXMapController : UIViewController
@property (nonatomic, strong) QXClinicModel *clinic;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longtitude;

@end

NS_ASSUME_NONNULL_END
