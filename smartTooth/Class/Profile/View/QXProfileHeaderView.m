//
//  QXProfileHeaderView.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/2.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXProfileHeaderView.h"
#import "QXTitleImageBtn.h"

@interface QXProfileHeaderView()
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *doctorDealView;
@property (nonatomic, weak) UIView *shopDealView;

@property (nonatomic, weak) UIImageView *avatarImgView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *couponNumLabel;
@property (nonatomic, weak) UILabel *collectNumLabel;
@property (nonatomic, weak) UILabel *attentionNumLabel;
@end

@implementation QXProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //个人信息
        [self setupInfoView];
        //诊疗订单
        //[self setupDoctorDealView];
        //购物订单
        //[self setupShopDealView];
    }
    return self;
}

- (void)setupInfoView {
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    self.topView = topView;
    topView.backgroundColor = UIColorHex(0x3594ff);
    [self addSubview:topView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editInfoAction:)];
    [topView addGestureRecognizer:tapGR];
    
    UIImageView *avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 60, 60)];
    self.avatarImgView = avatarImgView;
    avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImgView.layer.cornerRadius = avatarImgView.height/2;
    avatarImgView.layer.masksToBounds = YES;
    [avatarImgView setImageWithURL:[NSURL URLWithString:user.head] placeholder:[UIImage imageNamed:@"mylogin-tx"]];
    [topView addSubview:avatarImgView];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(avatarImgView.right + 10, 59, 200, 20)];
    self.nameLabel = nameLable;
    if (!ISNULL(user.cname)) {
        nameLable.text = [NSString stringWithFormat:@"%@",user.cname];
    } else {
        nameLable.text = @"登录更精彩！";
    }
    nameLable.font = [UIFont boldSystemFontOfSize:15];
    nameLable.textColor = UIColorHex(0xffffff);
    [topView addSubview:nameLable];
    
    UIImageView *indicatior = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 20, nameLable.top, 20, 20)];
    indicatior.contentMode = UIViewContentModeScaleAspectFit;
    indicatior.image = [UIImage imageNamed:@"myleftarrow"];
    [topView addSubview:indicatior];
    
    UILabel *couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLable.left, 102, 38, 17)];
    couponLabel.text = @"优惠券";
    couponLabel.font = [UIFont systemFontOfSize:12];
    couponLabel.textColor = UIColorHex(0xffffff);
    [topView addSubview:couponLabel];
    
    UILabel *couponNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponLabel.right + 4, couponLabel.top, 36, couponLabel.height)];
    self.couponNumLabel = couponNumLabel;
    couponNumLabel.text = @"0";
    couponNumLabel.textColor = UIColorHex(0xffffff);
    couponNumLabel.font = [UIFont boldSystemFontOfSize:14];
    [topView addSubview:couponNumLabel];
    
    UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(couponNumLabel.right, couponLabel.top, 38, couponLabel.height)];
    collectLabel.text = @"收藏夹";
    collectLabel.font = [UIFont systemFontOfSize:12];
    collectLabel.textColor = UIColorHex(0xffffff);
    //[topView addSubview:collectLabel];
    
    UILabel *collectNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(collectLabel.right + 4, collectLabel.top, 36, collectLabel.height)];
    self.collectNumLabel = collectNumLabel;
    collectNumLabel.text = @"0";
    collectNumLabel.textColor = UIColorHex(0xffffff);
    collectNumLabel.font = [UIFont boldSystemFontOfSize:14];
    //[topView addSubview:collectNumLabel];
    
    UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(collectNumLabel.right, couponLabel.top, 50, couponLabel.height)];
    attentionLabel.text = @"关注医师";
    attentionLabel.font = [UIFont systemFontOfSize:12];
    attentionLabel.textColor = UIColorHex(0xffffff);
    //[topView addSubview:attentionLabel];
    
    UILabel *attentionNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(attentionLabel.right + 4, attentionLabel.top, 36, attentionLabel.height)];
    self.attentionNumLabel = attentionNumLabel;
    attentionNumLabel.text = @"0";
    attentionNumLabel.textColor = UIColorHex(0xffffff);
    attentionNumLabel.font = [UIFont boldSystemFontOfSize:14];
    //[topView addSubview:attentionNumLabel];
    self.headerHeight = CGRectGetMaxY(topView.frame);
}

- (void)setupDoctorDealView {
    UIView *dealView = [[UIView alloc] initWithFrame:CGRectMake(10, 140, ScreenWidth - 20, 140)];
    self.doctorDealView = dealView;
    [self addSubview:dealView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:dealView.bounds];
    backImgView.image = [UIImage imageNamed:@"CARD"];
    [dealView addSubview:backImgView];
    
    UILabel *dealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    dealLabel.text = @"诊疗订单";
    dealLabel.font = [UIFont systemFontOfSize:14];
    dealLabel.textColor = UIColorHex(0x333333);
    [dealView addSubview:dealLabel];
    

    QXTitleImageBtn *arrowBtn = [[QXTitleImageBtn alloc] initWithTitle:@"全部" titleFont:[UIFont systemFontOfSize:14] titleColor:UIColorHex(0x979797) imageName:@"myorder-leftarrow" style:TitleImageBtnStyleRightImage leftMargin:0 centerMargin:4 rightMargin:0 frame:CGRectMake(dealView.width - 61, 18, 28, 24) isAutoWidth:NO];
    [arrowBtn addTarget:self action:@selector(allDoctorDealClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dealView addSubview:arrowBtn];
    
    NSArray *titleArray = @[@"咨询单",@"未消费",@"已消费",@"诊疗服务"];
    NSArray *imgArray = @[@"my_icon_01",@"my_icon_02",@"my_icon_03",@"my_icon_04"];
    for (int i = 0; i < titleArray.count; i++) {
        QXTitleImageBtn *dealBtn = [[QXTitleImageBtn alloc] initWithTitle:titleArray[i] titleFont:[UIFont systemFontOfSize:12] titleColor:UIColorHex(0x333333) imageName:imgArray[i] style:TitleImageBtnStyleTopImage leftMargin:0 centerMargin:10 rightMargin:0 frame:CGRectMake(i * dealView.width / titleArray.count, dealLabel.bottom + 30, dealView.width / titleArray.count, 70) isAutoWidth:NO];
        [dealView addSubview:dealBtn];
    }
}

- (void)setupShopDealView {
    UIView *dealView = [[UIView alloc] initWithFrame:CGRectMake(10, self.doctorDealView.bottom + 10, ScreenWidth - 20, 140)];
    self.shopDealView = dealView;
    [self addSubview:dealView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:dealView.bounds];
    backImgView.image = [UIImage imageNamed:@"CARD"];
    [dealView addSubview:backImgView];
    
    UILabel *dealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    dealLabel.text = @"购物订单";
    dealLabel.font = [UIFont systemFontOfSize:14];
    dealLabel.textColor = UIColorHex(0x333333);
    [dealView addSubview:dealLabel];
    
    
    QXTitleImageBtn *arrowBtn = [[QXTitleImageBtn alloc] initWithTitle:@"全部" titleFont:[UIFont systemFontOfSize:14] titleColor:UIColorHex(0x979797) imageName:@"myorder-leftarrow" style:TitleImageBtnStyleRightImage leftMargin:0 centerMargin:4 rightMargin:0 frame:CGRectMake(dealView.width - 61, 18, 28, 24) isAutoWidth:NO];
    [arrowBtn addTarget:self action:@selector(allShopDealClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dealView addSubview:arrowBtn];
    
    NSArray *titleArray = @[@"待付款",@"待发货",@"待收货",@"待点评"];
    NSArray *imgArray = @[@"my_icon_02",@"my_icon_05",@"my_icon_06",@"my_icon_07"];
    for (int i = 0; i < titleArray.count; i++) {
        QXTitleImageBtn *dealBtn = [[QXTitleImageBtn alloc] initWithTitle:titleArray[i] titleFont:[UIFont systemFontOfSize:12] titleColor:UIColorHex(0x333333) imageName:imgArray[i] style:TitleImageBtnStyleTopImage leftMargin:0 centerMargin:10 rightMargin:0 frame:CGRectMake(i * dealView.width / titleArray.count, dealLabel.bottom + 30, dealView.width / titleArray.count, 70) isAutoWidth:NO];
        [dealView addSubview:dealBtn];
    }
    self.headerHeight = CGRectGetMaxY(dealView.frame);
}


- (void)editInfoAction:(UIGestureRecognizer *)tapGR {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeaderView:didClickEditInfoAction:)]) {
        [self.delegate profileHeaderView:self didClickEditInfoAction:tapGR.view];
    }
}
- (void)allDoctorDealClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeaderView:didClickDoctorDealAction:)]) {
        [self.delegate profileHeaderView:self didClickDoctorDealAction:sender];
    }
}
- (void)allShopDealClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeaderView:didClickShopDealAction:)]) {
        [self.delegate profileHeaderView:self didClickShopDealAction:sender];
    }
}



- (void)updateHeaderView {
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    [self.avatarImgView setImageWithURL:[NSURL URLWithString:user.head] placeholder:[UIImage imageNamed:@"mylogin-tx"]];
    if (!ISNULL(user.cname)) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",user.cname];
    }
}
@end
