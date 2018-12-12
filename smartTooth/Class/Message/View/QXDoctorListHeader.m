//
//  QXDoctorListHeader.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctorListHeader.h"

@interface QXDoctorListHeader()

@end

@implementation QXDoctorListHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        backImgView.image = [UIImage imageNamed:@"mf_ask.jpg"];
        backImgView.userInteractionEnabled = YES;
        [self addSubview:backImgView];
//        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale6(70), 10, ScreenWidth, 22)];
//        firstLabel.text = @"认证值班医师";
//        firstLabel.textColor = UIColorHex(0x333333);
//        firstLabel.font = [UIFont systemFontOfSize:13];
//        [backImgView addSubview:firstLabel];
//
//        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.left, firstLabel.bottom + 4, ScreenWidth, 17)];
//        secondLabel.text = @"牙医在线专业医生提供服务";
//        secondLabel.font = [UIFont systemFontOfSize:12];
//        secondLabel.textColor = UIColorHex(0x979797);
//        [backImgView addSubview:secondLabel];
//
//        UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.left, secondLabel.bottom + 14, ScreenWidth, 17)];
//        thirdLabel.text = @"全天候随时响应";
//        thirdLabel.font = [UIFont systemFontOfSize:12];
//        thirdLabel.textColor = UIColorHex(0x333333);
//        [backImgView addSubview:thirdLabel];
//
//        UILabel *fouthLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstLabel.left, thirdLabel.bottom + 4, ScreenWidth, 17)];
//        fouthLabel.text = @"一对一咨询，保证隐私";
//        fouthLabel.font = [UIFont systemFontOfSize:12];
//        fouthLabel.textColor = UIColorHex(0x333333);
//        [backImgView addSubview:fouthLabel];
//
//        UIButton *askBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImgView.width - 10 - 88, 0, 88, 57)];
//        askBtn.centerY = backImgView.centerY;
//        [askBtn setTitle:@"免费咨询" forState:UIControlStateNormal];
//        askBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [askBtn setBackgroundImage:[UIImage imageNamed:@"BTN-S"] forState:UIControlStateNormal];
//        [askBtn setBackgroundImage:[UIImage imageNamed:@"BTN-S-select"] forState:UIControlStateHighlighted];
//        [backImgView addSubview:askBtn];
    }
    return self;
}

@end
