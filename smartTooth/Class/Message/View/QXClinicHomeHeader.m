//
//  QXClinicHomeHeader.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/22.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXClinicHomeHeader.h"
#import "QXClinicModel.h"
#import "QXTitleImageBtn.h"
@interface QXClinicHomeHeader()

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *centerView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *addressDescLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) QXTitleImageBtn *imageNumBtn;
@end
@implementation QXClinicHomeHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(0xffffff);
        [self setupTopView];
        [self setupCenterView];
    }
    return self;
}
- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightScale6(240))];
    self.topView = topView;
    [self addSubview:topView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightScale6(240))];
    self.backImgView = backImgView;
    backImgView.image = [UIImage imageNamed:@"zsxq_pic"];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    backImgView.clipsToBounds = YES;
    [topView addSubview:backImgView];
    
    QXTitleImageBtn *imageNumBtn = [[QXTitleImageBtn alloc] initWithTitle:@"1张图片" titleFont:[UIFont systemFontOfSize:12] titleColor:UIColorHex(0xffffff) imageName:@"pic-small" style:TitleImageBtnStyleLeftImage leftMargin:10 centerMargin:4 rightMargin:0 frame:CGRectMake(ScreenWidth - 11 - 89, topView.height - 20 - 25, 89, 25) isAutoWidth:NO];
    self.imageNumBtn = imageNumBtn;
    [imageNumBtn addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
    imageNumBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    imageNumBtn.layer.cornerRadius = imageNumBtn.height / 2;
    imageNumBtn.layer.masksToBounds = YES;
    [topView addSubview:imageNumBtn];
    
}
- (void)setupCenterView {
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom, ScreenWidth, 263)];
    self.centerView = centerView;
    [self addSubview:centerView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth - 50, 25)];
    self.nameLabel = nameLabel;
    //nameLabel.text = @"甄漂亮牙科诊所";
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textColor = UIColorHex(0x333333);
    [centerView addSubview:nameLabel];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.bottom + 10, ScreenWidth - 50, 17)];
    self.descLabel = descLabel;
    //descLabel.text = @"你的笑容就是我们的目标";
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = UIColorHex(0x979797);
    [centerView addSubview:descLabel];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, descLabel.bottom + 20, ScreenWidth, 1)];
    firstLine.backgroundColor = kLineColor;
    [centerView addSubview:firstLine];
    
    UIButton *clinicDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, firstLine.bottom)];
    [clinicDetailBtn addTarget:self action:@selector(clinicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:clinicDetailBtn];
    
    UIButton *indicatorView = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 0, 40, firstLine.bottom)];
    [indicatorView setImage:[UIImage imageNamed:@"myorder-leftarrow"] forState:UIControlStateNormal];
    [indicatorView addTarget:self action:@selector(clinicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:indicatorView];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, firstLine.bottom, ScreenWidth, 101)];
    [centerView addSubview:locationView];
    UIImageView *locaImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, locationView.height)];
    locaImgView.image = [UIImage imageNamed:@"dz_icon"];
    locaImgView.contentMode = UIViewContentModeScaleAspectFit;
    [locationView addSubview:locaImgView];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 20, ScreenWidth - 47 - 60 - 20, 40)];
    self.addressLabel = locationLabel;
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = UIColorHex(0x333333);
    locationLabel.numberOfLines = 0;
    [locationView addSubview:locationLabel];
    UILabel *addressDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationLabel.left, locationLabel.bottom + 4, locationLabel.width, 17)];
    self.addressDescLabel = addressDescLabel;
    addressDescLabel.font = [UIFont systemFontOfSize:12];
    addressDescLabel.textColor = UIColorHex(0x979797);
    [locationView addSubview:addressDescLabel];
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
    self.timeLabel = timeLabel;
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
    
    self.headerHeight = CGRectGetMaxY(centerView.frame);
}


- (void)setClinicModel:(QXClinicModel *)clinicModel
{
    _clinicModel = clinicModel;
    [self.backImgView setImageWithURL:[NSURL URLWithString:clinicModel.img] placeholder:[UIImage imageNamed:@"zsxq_pic"]];
    self.nameLabel.text = notNil(clinicModel.cname);
    self.descLabel.text = notNil(clinicModel.cdescribe);
    self.addressLabel.text = notNil(clinicModel.address);
    self.addressDescLabel.text = notNil(clinicModel.dp_address);
    self.timeLabel.text = notNil(clinicModel.worktime);
    self.imageNumBtn.customTitleLabel.text = [NSString stringWithFormat:@"%ld张图片",clinicModel.photos.count];
}

//地图
- (void)locationBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clinicHomeHeader:didClickLocationAction:)]) {
        [self.delegate clinicHomeHeader:self didClickLocationAction:_clinicModel];
    }
}
//打电话
- (void)phoneBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clinicHomeHeader:didClickPhoneAction:)]) {
        [self.delegate clinicHomeHeader:self didClickPhoneAction:_clinicModel];
    }
}

- (void)showPhotoBrowser:(QXTitleImageBtn *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clinicHomeHeader:showPhotoBrowser:)] && _clinicModel) {
        [self.delegate clinicHomeHeader:self showPhotoBrowser:_clinicModel];
    }
}

- (void)clinicBtnClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clinicHomeHeader:didClickClinic:)]) {
        [self.delegate clinicHomeHeader:self didClickClinic:_clinicModel];
    }
}
@end
