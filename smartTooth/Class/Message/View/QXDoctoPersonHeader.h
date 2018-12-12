//
//  QXDoctoPersonHeader.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/21.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QXDoctoPersonHeader,QXDoctorModel,QXClinicModel;

@protocol QXDoctoPersonHeaderDelegate <NSObject>
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickClinicAction:(QXClinicModel *)clinic;
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickLocationAction:(QXClinicModel *)clinic;
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickPhoneAction:(QXClinicModel *)clinic;
@end
@interface QXDoctoPersonHeader : UIView
/** 0:默认 1：诊所详情*/
@property (nonatomic, assign) NSInteger fromType;

@property (nonatomic, weak) UIImageView *topBackImgView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) QXDoctorModel *doctor;
@property (nonatomic, weak) id<QXDoctoPersonHeaderDelegate>delegate;
@end
