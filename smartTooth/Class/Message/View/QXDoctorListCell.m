//
//  QXDoctorListCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctorListCell.h"
#import "QXDoctorModel.h"
#import "QXLabelListView.h"
@interface QXDoctorListCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *askNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askWidthLayout;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeightConstraint;

@end
@implementation QXDoctorListCell

+(QXDoctorListCell*)getDoctorListCell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"QXDoctorListCell" owner:self options:nil]firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.avatarImgView.layer.cornerRadius = self.avatarImgView.height / 2;
    self.avatarImgView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.askWidthLayout.constant = WidthScale6(68);
    self.askHeightLayout.constant = WidthScale6(25);
    self.messageBtn.layer.cornerRadius = self.askHeightLayout.constant / 2;
    self.messageBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarDidClicked:)];
    self.avatarImgView.userInteractionEnabled = YES;
    [self.avatarImgView addGestureRecognizer:tapGR];
}

- (void)setDoctorModel:(QXDoctorModel *)doctorModel
{
    _doctorModel = doctorModel;
    [self.avatarImgView setImageWithURL:[NSURL URLWithString:doctorModel.headimg] placeholder:[UIImage imageNamed:@"lmlb_pic"]];
    self.nameLabel.text = notNil(doctorModel.name);
    self.zhiweiLabel.text = notNil(doctorModel.clinicname);
    if (doctorModel.aname.length > 0) {
        self.descLabel.text = [NSString stringWithFormat:@"%@  |  %@",notNil(doctorModel.title),notNil(doctorModel.aname)];
    } else {
        self.descLabel.text = [NSString stringWithFormat:@"%@",notNil(doctorModel.title)];
    }
    
    self.askNumLabel.text = [NSString stringWithFormat:@"资讯%ld人次",[doctorModel.consultnum integerValue]];
    if ([doctorModel.cost integerValue] > 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@/次",doctorModel.cost];
    }
    QXLabelListView *listView = [[QXLabelListView alloc] initWithFrame:self.labelView.bounds];
    listView.leftMargin = 0;
    listView.topMargin = 0;
    listView.labelList = [doctorModel.profession componentsSeparatedByString:@","];
    listView.height = listView.viewHeight;
    self.labelViewHeightConstraint.constant = listView.viewHeight;
    [self.labelView addSubview:listView];
}


- (IBAction)messageBtnDidClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doctorListCell:messageBtnClicked:)]) {
        [self.delegate doctorListCell:self messageBtnClicked:_doctorModel];
    }
}
- (void)avatarDidClicked:(UITapGestureRecognizer *)tapGR {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doctorListCell:avatarDidClicked:)]) {
        [self.delegate doctorListCell:self avatarDidClicked:_doctorModel];
    }
}


- (CGFloat)getHeightWithModel:(QXDoctorModel *)model
{
    NSArray *skillList = [model.profession componentsSeparatedByString:@","];
    CGFloat totalH = [QXLabelListView getHeightWithLabelList:skillList leftMargin:0 topMargin:0 totalWidth:ScreenWidth - 80];
    return 86 + totalH + 60;
}
@end
