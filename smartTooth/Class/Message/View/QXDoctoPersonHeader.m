//
//  QXDoctoPersonHeader.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/21.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctoPersonHeader.h"
#import "QXDoctorModel.h"
#import "QXClinicModel.h"
#import "QXLabelListView.h"
@interface QXDoctoPersonHeader()
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *centerView;
@property (nonatomic, weak) UIView *bottomView;


@property (nonatomic, weak) UIView *changeLine;
@property (nonatomic, weak) UIButton *zhenliaoBtn;
@property (nonatomic, weak) UIButton *recommendBtn;

@property (nonatomic, weak) UIImageView *avatarImgView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *zhiweiLabel;
@property (nonatomic, weak) UILabel *numLabel;
@property (nonatomic, weak) UILabel *clinicNameLabel;
@property (nonatomic, weak) UILabel *clinicAddressLabel;
@property (nonatomic, weak) UILabel *clinicAddressDesc;
@property (nonatomic, weak) UILabel *clinicTimeLabel;

@property (nonatomic, weak) QXLabelListView *labelView;
@property (nonatomic, weak) UIView *labelLine;
@end

@implementation QXDoctoPersonHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupTopView];//顶部的view
        [self setupCenterView];//中间的view
    }
    return self;
}
- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    self.topView = topView;
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    self.topBackImgView = backImgView;
    backImgView.image = [UIImage imageNamed:@"yszy"];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    backImgView.clipsToBounds = YES;
    [topView addSubview:backImgView];
  
    UIImageView *avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topView.height - 20 - 88, 88, 88)];
    self.avatarImgView = avatarImgView;
    avatarImgView.image = [UIImage imageNamed:@"lmlb_pic"];
    avatarImgView.layer.cornerRadius = avatarImgView.height/2;
    avatarImgView.layer.masksToBounds = YES;
    [topView addSubview:avatarImgView];
    backImgView.height = avatarImgView.bottom + 20;
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImgView.right + 10, avatarImgView.top + 5, 200, 20)];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor whiteColor];
    [topView addSubview:nameLabel];
    
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, 200, 17)];
    self.zhiweiLabel = positionLabel;
    positionLabel.font = [UIFont systemFontOfSize:12];
    positionLabel.textColor = [UIColor whiteColor];
    [topView addSubview:positionLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, positionLabel.bottom + 15, 200, 16)];
    self.numLabel = numLabel;
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textColor = [UIColor whiteColor];
    [topView addSubview:numLabel];
    
    QXLabelListView *labelView = [[QXLabelListView alloc] initWithFrame:CGRectMake(0, backImgView.bottom, ScreenWidth, 60)];
    self.labelView = labelView;
    labelView.leftMargin = 10;
    labelView.topMargin = (60 - 17)/2;
    [topView addSubview:labelView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelView.bottom, ScreenWidth, 10)];
    self.labelLine = lineView;
    lineView.backgroundColor = UIColorHex(0xf2f2f2);
    [topView addSubview:lineView];
    
    topView.height = lineView.bottom;
}
- (void)setupCenterView {
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom, ScreenWidth, 240)];
    self.centerView = centerView;
    [self addSubview:centerView];
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clinicBtnClicked:)];
    [nameView addGestureRecognizer:tapGR];
    [centerView addSubview:nameView];
    UIImageView *nameImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 24, nameView.height)];
    nameImgView.image = [UIImage imageNamed:@"yiyuan"];
    nameImgView.contentMode = UIViewContentModeScaleAspectFit;
    [nameView addSubview:nameImgView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, ScreenWidth - 47, nameView.height)];
    self.clinicNameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = UIColorHex(0x333333);
    [nameView addSubview:nameLabel];
    UIButton *indicatorView = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 0, 40, nameView.height)];
    [indicatorView setImage:[UIImage imageNamed:@"myorder-leftarrow"] forState:UIControlStateNormal];
    [indicatorView addTarget:self action:@selector(clinicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nameView addSubview:indicatorView];
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.left, nameView.bottom - 1, ScreenWidth - nameLabel.left, 1)];
    nameLine.backgroundColor = kLineColor;
    [nameView addSubview:nameLine];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.bottom, ScreenWidth, 101)];
    [centerView addSubview:locationView];
    UIImageView *locaImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, locationView.height)];
    locaImgView.image = [UIImage imageNamed:@"dz_icon"];
    locaImgView.contentMode = UIViewContentModeScaleAspectFit;
    [locationView addSubview:locaImgView];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 20, ScreenWidth - 47 - 60 - 20, 40)];
    self.clinicAddressLabel = locationLabel;
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = UIColorHex(0x333333);
    locationLabel.numberOfLines = 0;
    [locationView addSubview:locationLabel];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationLabel.left, locationLabel.bottom + 4, locationLabel.width, 17)];
    self.clinicAddressDesc = descLabel;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = UIColorHex(0x979797);
    [locationView addSubview:descLabel];
    UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 62, 0, 62, locationView.height)];
    [locationBtn setImage:[UIImage imageNamed:@"ditu"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"ditu"] forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [locationView addSubview:locationBtn];
    
    UIView *locaLine = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.left, locationView.height - 1, ScreenWidth - locationLabel.left, 1)];
    locaLine.backgroundColor = kLineColor;
    [locationView addSubview:locaLine];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, locationView.bottom, ScreenWidth, 60)];
    [centerView addSubview:timeView];
    UIImageView *timeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, timeView.height)];
    timeImgView.contentMode = UIViewContentModeScaleAspectFit;
    timeImgView.image = [UIImage imageNamed:@"shijian"];
    [timeView addSubview:timeImgView];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, ScreenWidth - 47 - 60, timeView.height)];
    self.clinicTimeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = UIColorHex(0x333333);
    [timeView addSubview:timeLabel];
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 62, 0, 62, timeView.height)];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self action:@selector(phoneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:phoneBtn];
    
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(0, timeView.bottom, ScreenWidth, 10)];
    centerLine.backgroundColor = UIColorHex(0xf2f2f2);
    [centerView addSubview:centerLine];
    
    self.headerHeight = centerView.bottom;
}
- (void)setFromType:(NSInteger)fromType
{
    _fromType = fromType;
    if (fromType == 1) {
        [self.centerView removeFromSuperview];
    }
}

- (void)setDoctor:(QXDoctorModel *)doctor
{
    _doctor = doctor;
    [self.avatarImgView setImageWithURL:[NSURL URLWithString:doctor.headimg] placeholder:[UIImage imageNamed:@"lmlb_pic"]];
    self.nameLabel.text = notNil(doctor.name);
    self.zhiweiLabel.text = [NSString stringWithFormat:@"%@ | %@",notNil(doctor.title),notNil(doctor.aname)];
    //self.numLabel.text = [NSString stringWithFormat:@"%@人资讯    %@人关注",notNil(doctor.consultnum),notNil(doctor.isown)];
    if (!ISNULL(doctor.clinic)) {
        QXClinicModel *clinic = doctor.clinic;
        //[self.topBackImgView setImageWithURL:[NSURL URLWithString:clinic.img] placeholder:[UIImage imageNamed:@"yszy"]];
        self.clinicNameLabel.text = clinic.cname;
        self.clinicAddressLabel.text = notNil(clinic.address);
        self.clinicAddressDesc.text = notNil(clinic.dp_address);
        self.clinicTimeLabel.text = notNil(clinic.worktime);
    }
    NSArray *profession = [doctor.profession componentsSeparatedByString:@","];
    self.labelView.labelList = profession;
    
    CGFloat totalH = [QXLabelListView getHeightWithLabelList:profession leftMargin:self.labelView.leftMargin topMargin:self.labelView.topMargin totalWidth:ScreenWidth];
    self.labelView.height = totalH;
    self.labelLine.top = self.labelView.bottom;
    self.topView.height = CGRectGetMaxY(self.labelLine.frame);
    if (self.fromType == 1) {
        self.headerHeight = CGRectGetMaxY(self.topView.frame);
    } else {
        self.centerView.top = self.topView.bottom;
        self.headerHeight = CGRectGetMaxY(self.centerView.frame);
    }
}

//诊所
- (void)clinicBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doctorHeader:didClickClinicAction:)] && _doctor.clinic) {
        [self.delegate doctorHeader:self didClickClinicAction:_doctor.clinic];
    }
}
//地图
- (void)locationBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doctorHeader:didClickLocationAction:)] && _doctor.clinic) {
        [self.delegate doctorHeader:self didClickLocationAction:_doctor.clinic];
    }
}
//打电话
- (void)phoneBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doctorHeader:didClickPhoneAction:)] && _doctor.clinic) {
        [self.delegate doctorHeader:self didClickPhoneAction:_doctor.clinic];
    }
}
@end
