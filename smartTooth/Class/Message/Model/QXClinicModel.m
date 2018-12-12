//
//  QXClinicModel.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXClinicModel.h"
#import "QXDoctorModel.h"
#import "QXPhotoModel.h"
@implementation QXClinicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"doctors":[QXDoctorModel class],@"photos":[QXPhotoModel class]};
}
@end
