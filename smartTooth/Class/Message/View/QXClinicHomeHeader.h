//
//  QXClinicHomeHeader.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/22.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXClinicHomeHeader,QXClinicModel;
@protocol QXClinicHomeHeaderDelegate <NSObject>
- (void)clinicHomeHeader:(QXClinicHomeHeader *)headerView didClickLocationAction:(QXClinicModel *)clinic;
- (void)clinicHomeHeader:(QXClinicHomeHeader *)headerView didClickPhoneAction:(QXClinicModel *)clinic;
- (void)clinicHomeHeader:(QXClinicHomeHeader *)headerView showPhotoBrowser:(QXClinicModel *)clinic;
- (void)clinicHomeHeader:(QXClinicHomeHeader *)headerView didClickClinic:(QXClinicModel *)clinic;
@end

@interface QXClinicHomeHeader : UIView
@property (nonatomic, weak) id<QXClinicHomeHeaderDelegate>delegate;
@property (nonatomic, strong) QXClinicModel *clinicModel;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, weak) UIImageView *backImgView;
@end
