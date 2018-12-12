//
//  QXUserInfoCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXUserInfoCell : UITableViewCell
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, weak) UIImageView *avatarImgView;
@property (nonatomic, weak) UIView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
