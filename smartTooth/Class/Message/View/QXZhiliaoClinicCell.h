//
//  QXZhiliaoClinicCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXZhiliaoClinicCell,QXClinicModel,QXDoctorModel;
@protocol QXZhiliaoClinicCellDelegate <NSObject>
- (void)clinicCell:(QXZhiliaoClinicCell *)cell didClickClinicBtn:(QXClinicModel *)clinic;
- (void)clinicCell:(QXZhiliaoClinicCell *)cell didClickDoctorBtn:(QXDoctorModel *)doctor;
@end

@interface QXZhiliaoClinicCell : UITableViewCell
@property (nonatomic, weak) id<QXZhiliaoClinicCellDelegate>delegate;
@property (nonatomic, strong) QXClinicModel *clinicModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
