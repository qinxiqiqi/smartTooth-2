//
//  QXProfileCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXProfileCell.h"

@implementation QXProfileCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXProfileCell"];
    if (!cell) {
        cell = [[QXProfileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXProfileCell"];
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
    CGFloat cellHeight = ScreenWidth * 120 / 747;
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cellHeight)];
    self.backImgView = backImgView;
    [self.contentView addSubview:backImgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 200, cellHeight)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColorHex(0x333333);
    [self.contentView addSubview:titleLabel];
}

@end
