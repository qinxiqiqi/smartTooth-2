//
//  WifiListCell.h
//  SmartTooth
//
//  Created by qinxi on 2018/10/29.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QXWifiModel;

@interface WifiListCell : UITableViewCell

@property (nonatomic, strong) QXWifiModel *wifiModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *wifiName;

@end

NS_ASSUME_NONNULL_END
