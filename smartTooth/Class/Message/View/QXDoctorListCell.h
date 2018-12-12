//
//  QXDoctorListCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXDoctorListCell,QXDoctorModel;
@protocol QXDoctorListCellDelegate <NSObject>
- (void)doctorListCell:(QXDoctorListCell *)cell messageBtnClicked:(QXDoctorModel *)doctor;
- (void)doctorListCell:(QXDoctorListCell *)cell avatarDidClicked:(QXDoctorModel *)doctor;
@end

@interface QXDoctorListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (nonatomic, strong) QXDoctorModel *doctorModel;
@property (nonatomic, weak) id<QXDoctorListCellDelegate>delegate;
+(instancetype)getDoctorListCell;
- (CGFloat)getHeightWithModel:(QXDoctorModel *)model;
@end
