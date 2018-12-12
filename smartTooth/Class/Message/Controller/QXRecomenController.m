//
//  QXRecomenController.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXRecomenController.h"
#import "QXDoctorListCell.h"
#import "QXMessageController.h"
#import "QXDoctorPersonController.h"
#import "QXDoctorModel.h"
#import "QXDoctorServeCell.h"
@interface QXRecomenController ()<UITableViewDelegate,UITableViewDataSource,QXDoctorListCellDelegate>
@property (nonatomic, assign) CGPoint lastContentOffset;

@end

@implementation QXRecomenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    // Do any additional setup after loading the view.
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXDoctorServeCell *cell = [QXDoctorServeCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (void)doctorListCell:(QXDoctorListCell *)cell messageBtnClicked:(QXDoctorModel *)doctor
{
    QXMessageController *messageVC = [[QXMessageController alloc] initWithConversationChatter:doctor.phone conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:messageVC animated:YES];
}
- (void)doctorListCell:(QXDoctorListCell *)cell avatarDidClicked:(QXDoctorModel *)doctor
{
    QXDoctorPersonController *personVC = [[QXDoctorPersonController alloc] init];
    personVC.doctorModel = doctor;
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildScrollViewDidScrollNSNotification" object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}
@end
