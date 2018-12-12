//
//  QXClinicModel.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXClinicModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *cdescribe;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *ischoice;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *axphone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *worktime;
/** 诊所副名称*/
@property (nonatomic, copy) NSString *dp_cname;
/** 人工地址*/
@property (nonatomic, copy) NSString *dp_address;
@property (nonatomic, copy) NSString *curl;
/** 相册*/
@property (nonatomic, strong) NSArray *photos;
@end
