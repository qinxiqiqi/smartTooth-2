//
//  QXDoctorPersonController.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QXDoctorModel;
@interface QXDoctorPersonController : UIViewController
/** 0:默认 1：诊所详情*/
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, strong) QXDoctorModel *doctorModel;
@end
