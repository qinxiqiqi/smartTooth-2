//
//  QXDoctorServeCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/21.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctorServeCell.h"

@interface QXDoctorServeCell()
@property (nonatomic, weak) UIImageView *thumbImgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *moneyLabel;
@end

@implementation QXDoctorServeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXDoctorServeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXDoctorServeCell"];
    if (!cell) {
        cell = [[QXDoctorServeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXDoctorServeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIImageView *thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 90, 65)];
    self.thumbImgView = thumbImgView;
    thumbImgView.image = [UIImage imageNamed:@"fwxq_item"];
    thumbImgView.layer.cornerRadius = 5;
    thumbImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:thumbImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(thumbImgView.right + 20, thumbImgView.top, ScreenWidth - thumbImgView.right, 15)];
    self.titleLabel = titleLabel;
    titleLabel.text = @"仅售280，价值500元超声波洗牙";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, thumbImgView.bottom - 15, 200, 15)];
    self.moneyLabel = moneyLabel;
    moneyLabel.text = @"￥280/次";
    moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:moneyLabel];
}

@end
