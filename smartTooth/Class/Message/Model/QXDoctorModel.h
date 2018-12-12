//
//  QXDoctorModel.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QXClinicModel;

@interface QXDoctorModel : NSObject
@property (nonatomic, copy) NSString *aname;
@property (nonatomic, copy) NSString *clinic_id;
@property (nonatomic, copy) NSString *clinicname;
@property (nonatomic, copy) NSString *consultnum;
@property (nonatomic, copy) NSString *cost;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *isown;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *durl;
@property (nonatomic, strong) QXClinicModel *clinic;
@end
