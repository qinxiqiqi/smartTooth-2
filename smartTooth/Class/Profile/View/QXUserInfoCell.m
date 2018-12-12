//
//  QXUserInfoCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXUserInfoCell.h"

@interface QXUserInfoCell()

@end

@implementation QXUserInfoCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXUserInfoCell"];
    if (!cell) {
        cell = [[QXUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXUserInfoCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    UILabel *leftLabel = [[UILabel alloc] init];
    self.leftLabel = leftLabel;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = UIColorHex(0x333333);
    [self.contentView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    self.rightLabel = rightLabel;
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textColor = UIColorHex(0x333333);
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    
    UIImageView *avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - 34, 20, 60, 60)];
    self.avatarImgView = avatarImgView;
    avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImgView.layer.cornerRadius = avatarImgView.height/2;
    avatarImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:avatarImgView];
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftLabel.frame = CGRectMake(10, 0, 200, self.height);
    self.rightLabel.frame = CGRectMake(ScreenWidth - 200 - 34, 0, 200, self.height);
    self.lineView.frame = CGRectMake(44, self.height - 1, ScreenWidth - 44, 1);
}

@end
