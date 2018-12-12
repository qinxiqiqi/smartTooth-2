//
//  WifiListCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/29.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "WifiListCell.h"
#import "QXWifiModel.h"

@implementation WifiListCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WifiListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WifiListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WifiListCell" owner:self options:nil]firstObject];
    }
    return cell;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWifiModel:(QXWifiModel *)wifiModel
{
    _wifiModel = wifiModel;
    self.wifiName.text = wifiModel.SSID;
}

@end
