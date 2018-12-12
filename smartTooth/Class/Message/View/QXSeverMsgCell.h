//
//  QXSeverMsgCell.h
//  smartTooth
//
//  Created by qinxi on 2018/11/6.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QXSeverModel;

@interface QXSeverMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (nonatomic, strong) QXSeverModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
