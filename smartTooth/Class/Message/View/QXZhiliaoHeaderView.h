//
//  QXZhiliaoHeaderView.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DoctorHeaderType){
    DoctorHeaderTypeQuick,//快速
    DoctorHeaderTypeFamous,//问名医
    DoctorHeaderTypeFree,//义诊专区
    DoctorHeaderTypeErya,
    DoctorHeaderTypeQuchi,
    DoctorHeaderTypeJiaozheng,
    DoctorHeaderTypeMeibai,
    DoctorHeaderTypeXiya,
    DoctorHeaderTypeBaya,
    DoctorHeaderTypeBuya,
    DoctorHeaderTypeZhongzhi
};

@class QXZhiliaoHeaderView;
@protocol QXZhiliaoHeaderViewDelegate <NSObject>
- (void)headerView:(QXZhiliaoHeaderView *)headerView linkDoctroAction:(DoctorHeaderType)linkType;
@end

@interface QXZhiliaoHeaderView : UIView
@property (nonatomic, weak) id<QXZhiliaoHeaderViewDelegate>delegate;
@end
