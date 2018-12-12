//
//  QXCityCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/8/20.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXCityCell : UITableViewCell
@property (nonatomic, weak) UILabel *cityLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
