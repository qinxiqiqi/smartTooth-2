//
//  QXZhiliaoHeaderView.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#define questionBaseTag  2000

#define kDoctorViewH 180
#define kQuetionViewH 50
#define kListViewH 140

#import "QXZhiliaoHeaderView.h"
#import "QXTitleImageBtn.h"

@interface QXZhiliaoHeaderView()

@property (nonatomic, weak) UIScrollView *questionScrollView;

@end
@implementation QXZhiliaoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDoctorView];
        [self setupQuestionView];
        [self setupListView];
    }
    return self;
}

- (void)setupDoctorView {
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, 5, ScreenWidth - zlLeftMargin * 2, 84)];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkDoctorAction:)];
    [borderView addGestureRecognizer:tapGR];
    [self addSubview:borderView];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:borderView.bounds];
    backImgView.image = [UIImage imageNamed:@"CARD"];
    [borderView addSubview:backImgView];
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (borderView.height - 44)/2, 44, 44)];
    leftImgView.image = [UIImage imageNamed:@"kuaisu"];
    [borderView addSubview:leftImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImgView.right + 10, leftImgView.top, 95, 25)];
    titleLabel.text = @"快速问医生";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = UIColorHex(0x333333);
    [borderView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top+2, 80, 20)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = @"7 x 24小时";
    descLabel.textColor = UIColorHex(0x2f71ff);
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.layer.cornerRadius = 5;
    descLabel.layer.masksToBounds = YES;
    descLabel.layer.borderWidth = 1;
    descLabel.layer.borderColor = UIColorHex(0x2f71ff).CGColor;
    [borderView addSubview:descLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImgView.right + 10, titleLabel.bottom + 2, 200, 17)];
    bottomLabel.text = @"健康咨询 看病开药";
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = UIColorHex(0x979797);
    [borderView addSubview:bottomLabel];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(borderView.width - 10 - 24, (borderView.height - 24)/2, 24, 24)];
    rightArrow.image = [UIImage imageNamed:@"black-leftarrow"];
    [borderView addSubview:rightArrow];
    
    //问名医
    UIView *famouView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, borderView.bottom, (ScreenWidth - zlLeftMargin * 2 - 10)/2, 84)];
    UITapGestureRecognizer *famouTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkFamouAction:)];
    [famouView addGestureRecognizer:famouTap];
    [self addSubview:famouView];
    
    UIImageView *famouBackImage = [[UIImageView alloc] initWithFrame:famouView.bounds];
    famouBackImage.image = [UIImage imageNamed:@"CARD"];
    [famouView addSubview:famouBackImage];
    
    UIImageView *famouImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (borderView.height - 44)/2, 44, 44)];
    famouImgView.image = [UIImage imageNamed:@"zhuanjia"];
    [famouView addSubview:famouImgView];
    
    UILabel *famouLabel = [[UILabel alloc] initWithFrame:CGRectMake(famouImgView.right + 10, famouImgView.top, famouView.width - famouImgView.right - 10, 25)];
    famouLabel.text = @"问名医";
    famouLabel.font = [UIFont systemFontOfSize:18];
    famouLabel.textColor = UIColorHex(0x333333);
    [famouView addSubview:famouLabel];
    
    
    UILabel *famouDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(famouImgView.right + 10, famouLabel.bottom + 2, famouView.width - famouImgView.right - 10, 20)];
    famouDescLabel.text = @"专家名医在线解答";
    famouDescLabel.font = [UIFont systemFontOfSize:12];
    famouDescLabel.textColor = UIColorHex(0x979797);
    famouDescLabel.numberOfLines = 2;
    [famouView addSubview:famouDescLabel];
    
    UIView *yizhenView = [[UIView alloc] initWithFrame:CGRectMake(famouView.right + 5, famouView.top, famouView.width, famouView.height)];
    UITapGestureRecognizer *yizhenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkYizhenAction:)];
    [yizhenView addGestureRecognizer:yizhenTap];
    [self addSubview:yizhenView];
    
    UIImageView *yizhenBackImage = [[UIImageView alloc] initWithFrame:yizhenView.bounds];
    yizhenBackImage.image = [UIImage imageNamed:@"CARD"];
    [yizhenView addSubview:yizhenBackImage];
    
    UIImageView *yizhenImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (borderView.height - 44)/2, 44, 44)];
    yizhenImgView.image = [UIImage imageNamed:@"yizhen"];
    [yizhenView addSubview:yizhenImgView];
    
    UILabel *yizhenLabel = [[UILabel alloc] initWithFrame:CGRectMake(yizhenImgView.right + 10, yizhenImgView.top, yizhenView.width - yizhenImgView.right - 10, 25)];
    yizhenLabel.text = @"义诊专区";
    yizhenLabel.font = [UIFont systemFontOfSize:18];
    yizhenLabel.textColor = UIColorHex(0x333333);
    [yizhenView addSubview:yizhenLabel];
    
    
    UILabel *yizhenDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(yizhenImgView.right + 10, yizhenLabel.bottom + 2, yizhenView.width - yizhenImgView.right - 10, 20)];
    yizhenDescLabel.text = @"爱心专家特惠问诊";
    yizhenDescLabel.font = [UIFont systemFontOfSize:12];
    yizhenDescLabel.textColor = UIColorHex(0x979797);
    [yizhenView addSubview:yizhenDescLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, kDoctorViewH - 1, ScreenWidth - 2 * zlLeftMargin, 1)];
    lineView.backgroundColor = kLineColor;
    [self addSubview:lineView];
}
- (void)setupQuestionView {
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, kDoctorViewH, ScreenWidth - zlLeftMargin, kQuetionViewH)];
    [self addSubview:questionView];
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (questionView.height - 34)/2, 34, 34)];
    leftImgView.image = [UIImage imageNamed:@"cjwt"];
    [questionView addSubview:leftImgView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftImgView.right, 0, questionView.width - leftImgView.right, questionView.height)];
    self.questionScrollView = scrollView;
    [questionView addSubview:scrollView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, questionView.height - 1, ScreenWidth - 2 * zlLeftMargin, 1)];
    line.backgroundColor = kLineColor;
    [questionView addSubview:line];
}
- (void)setupListView {
    
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, kDoctorViewH + kQuetionViewH, ScreenWidth, kListViewH)];
    [self addSubview:listView];
    
    NSArray *imageArray = @[@"erya",@"zhuya",@"jiaozheng",@"meibai",@"xiya",@"baya",@"buya",@"zhongzhi"];
    NSArray *titleArray = @[@"儿牙",@"龋齿",@"矫正",@"美白",@"洗牙",@"拔牙",@"补牙",@"种植"];
    NSInteger maxCols = 4;//一行最大个数
    for (int i = 0; i < titleArray.count; i++) {
        // 行号
        int row = i / maxCols;
        // 列号
        int col = i % maxCols;
        QXTitleImageBtn *button = [[QXTitleImageBtn alloc] initWithTitle:titleArray[i] titleFont:[UIFont systemFontOfSize:12] titleColor:UIColorHex(0x121212) imageName:imageArray[i] style:TitleImageBtnStyleTopImage leftMargin:10 centerMargin:5 rightMargin:0 frame:CGRectMake(col * (listView.width / maxCols), row * (listView.height / 2), listView.width / maxCols, listView.height / 2) isAutoWidth:NO];
        [listView addSubview:button];
        button.tag = questionBaseTag + i;
        [button addTarget:self action:@selector(clickQuestionTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}


//点击快速问医生
- (void)linkDoctorAction:(UITapGestureRecognizer *)tapGR {
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:linkDoctroAction:)]) {
        [self.delegate headerView:self linkDoctroAction:DoctorHeaderTypeQuick];
    }
}
- (void)linkFamouAction:(UITapGestureRecognizer *)tapGR {
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:linkDoctroAction:)]) {
        [self.delegate headerView:self linkDoctroAction:DoctorHeaderTypeFamous];
    }
}
- (void)linkYizhenAction:(UITapGestureRecognizer *)tapGR {
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:linkDoctroAction:)]) {
        [self.delegate headerView:self linkDoctroAction:DoctorHeaderTypeFree];
    }
}

- (void)clickQuestionTypeBtn:(UIButton *)sender {
    NSInteger tag = sender.tag - questionBaseTag + 3;
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:linkDoctroAction:)]) {
        [self.delegate headerView:self linkDoctroAction:tag];
    }
}
@end
