//
//  QXCityCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/20.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXCityCell.h"

@interface QXCityCell()

@end

@implementation QXCityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXCityCell"];
    if (!cell) {
        cell = [[QXCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXCityCell"];
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
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 12, 50)];
    self.cityLabel = cityLabel;
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.textColor = UIColorHex(0x333333);
    [self.contentView addSubview:cityLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49, ScreenWidth - 30, 1)];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];
}

@end
