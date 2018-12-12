//
//  QXSeverMsgCell.m
//  smartTooth
//
//  Created by qinxi on 2018/11/6.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXSeverMsgCell.h"
#import "QXSeverModel.h"

@implementation QXSeverMsgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXSeverMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXSeverMsgCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"QXSeverMsgCell" owner:self options:nil]firstObject];
    }
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)setModel:(QXSeverModel *)model
{
    _model = model;
    self.nameLabel.text = model.nickName;
    if (model.isWork) {
        self.workLabel.text = @"在线";
    } else {
        self.workLabel.text = @"离线";
    }
}
@end
