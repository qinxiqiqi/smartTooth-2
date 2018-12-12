//
//  QXDoctroListController.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXBaseViewController.h"

@interface QXDoctroListController : QXBaseViewController
/** 0:默认 1：诊所详情*/
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, copy) NSString *doctorType;
/** 城市*/
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
