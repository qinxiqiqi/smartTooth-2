//
//  WifiListView.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/29.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "WifiListView.h"
#import "WifiListCell.h"
#import "QXWifiModel.h"
@interface WifiListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation WifiListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView {
    UIView *corverView = [[UIView alloc] initWithFrame:CGRectMake(50, (ScreenHeight - WidthScale6(568)) / 2, ScreenWidth - 100, WidthScale6(568))];
    corverView.backgroundColor = UIColorHex(0xffffff);
    corverView.layer.cornerRadius = 30;
    corverView.layer.masksToBounds = YES;
    [self addSubview:corverView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, corverView.width, 64)];
    label.text = @"选择无线网络";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = UIColorHex(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    [corverView addSubview:label];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, corverView.height - 45, corverView.width, 45)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:UIColorHex(0x0060f0) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [corverView addSubview:cancelBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.bottom, corverView.width, corverView.height - label.height - cancelBtn.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [corverView addSubview:tableView];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        [tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [tableView registerNib:[UINib nibWithNibName:@"WifiListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WifiListCell"];
}


- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WifiListCell *cell = [WifiListCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        QXWifiModel *model = self.dataArray[indexPath.row];
        cell.wifiModel = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wifiListView:didClickWifi:)]) {
        [self.delegate wifiListView:self didClickWifi:self.dataArray[indexPath.row]];
    }
}

- (void)showInView:(UIView *)view
{
    self.backgroundColor = UIColorHex(0xefeff4);
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}


- (void)dismissView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}
@end
