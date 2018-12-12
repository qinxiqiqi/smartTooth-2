//
//  QXClinicCollectionCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/15.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXClinicCollectionCell.h"
#import "QXDoctorModel.h"

@interface QXClinicCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarIMgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ziliLabel;

@end

@implementation QXClinicCollectionCell

- (void)setDoctor:(QXDoctorModel *)doctor
{
    _doctor = doctor;
    [self.avatarIMgView setImageWithURL:[NSURL URLWithString:doctor.headimg] placeholder:[UIImage imageNamed:@"yisheng_pic"]];
    self.nameLabel.text = doctor.name;
    self.ziliLabel.text = doctor.title;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.avatarIMgView.layer.cornerRadius = 5;
    self.avatarIMgView.layer.masksToBounds = YES;
    self.ziliLabel.layer.borderWidth = 1;
    self.ziliLabel.layer.borderColor = UIColorHex(0x0060f0).CGColor;
    self.ziliLabel.layer.cornerRadius = 4;
    self.ziliLabel.layer.masksToBounds = YES;
}
@end
