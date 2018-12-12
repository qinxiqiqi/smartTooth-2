//
//  QXDoctorWebController.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/24.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctorWebController.h"
#import <WebKit/WebKit.h>
#import "QXWebCell.h"
@interface QXDoctorWebController ()<UITableViewDelegate,UITableViewDataSource,QXWebCellDelegate>
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) CGFloat webViewH;
@end

@implementation QXDoctorWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.backgroundColor = UIColorHex(0xf2f6f2);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        [tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXWebCell *cell = [QXWebCell cellWithTableView:tableView];
    cell.requestUrl = self.requestUrl;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.webViewH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildScrollViewDidScrollNSNotification" object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}

- (void)webViewLoadFinish:(CGFloat)webViewHeight
{
    self.webViewH = webViewHeight;
    [self.tableView reloadData];
}
@end
