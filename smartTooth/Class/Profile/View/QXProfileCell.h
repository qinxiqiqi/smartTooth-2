//
//  QXProfileCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXProfileCell : UITableViewCell
@property (nonatomic, weak) UIImageView *backImgView;
@property (nonatomic, weak) UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
