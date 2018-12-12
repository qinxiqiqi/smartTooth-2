//
//  QXDoctroListController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctroListController.h"
#import "QXDoctorListCell.h"
#import "QXMessageController.h"
#import "QXDoctorPersonController.h"
#import "QXDoctorModel.h"
#import "QXDoctorListHeader.h"
#import "QXServerMsgListController.h"
#import "QXServiceMessageController.h"
@interface QXDoctroListController ()<UITableViewDelegate,UITableViewDataSource,QXDoctorListCellDelegate>
{
    NSInteger _page;
}
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) QXDoctorListHeader *headerView;
@end

@implementation QXDoctroListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    if (self.dataArray.count == 0) {
        [self getDoctorList];
    }
}
- (void)setupTableView {
 
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.width, ScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    if (_fromType == 1) {
        tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
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
    [tableView registerNib:[UINib nibWithNibName:@"QXDoctorListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QXDoctorListCell"];
    if (_fromType != 1) {
        tableView.tableHeaderView = self.headerView;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXDoctorListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QXDoctorListCell"];
    if (!cell) {
        cell = [QXDoctorListCell getDoctorListCell];
    }
    if (self.dataArray.count > 0) {
        cell.doctorModel = self.dataArray[indexPath.row];
        if (self.fromType == 1) {
            cell.zhiweiLabel.hidden = YES;
        }
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXDoctorListCell *cell = [QXDoctorListCell new];
    return [cell getHeightWithModel:self.dataArray[indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXDoctorPersonController *personVC = [[QXDoctorPersonController alloc] init];
    personVC.fromType = self.fromType;
    personVC.doctorModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)doctorListCell:(QXDoctorListCell *)cell messageBtnClicked:(QXDoctorModel *)doctor
{
    QXMessageController *messageVC = [[QXMessageController alloc] initWithConversationChatter:doctor.phone conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:messageVC animated:YES];
}
- (void)doctorListCell:(QXDoctorListCell *)cell avatarDidClicked:(QXDoctorModel *)doctor
{
    QXDoctorPersonController *personVC = [[QXDoctorPersonController alloc] init];
    personVC.fromType = self.fromType;
    personVC.doctorModel = doctor;
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChildScrollViewDidScrollNSNotification" object:nil userInfo:@{@"scrollingScrollView":scrollView,@"offsetDifference":@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}
    
- (void)clickSeverMessage {
//    QXServerMsgListController *msgListVC = [[QXServerMsgLi1stController alloc] init];
//    [self.navigationController pushViewController:msgListVC animated:YES];
    QXServiceMessageController *chatVC = [[QXServiceMessageController alloc] initWithConversationChatter:@"15801449477"]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma mark - 请求网络接口
- (void)getDoctorList {
    _page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(_page);
    param[@"city"] = self.city;
    param[@"type"] = self.doctorType;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_DOCTOR_LIST alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.dataArray removeAllObjects];
            if (ISNULL(responseObject[@"data"])) {
                return ;
            }
            self.dataArray = [QXDoctorModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (QXDoctorListHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[QXDoctorListHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale6(171))];
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSeverMessage)];
        [_headerView addGestureRecognizer:tapGR];
    }
    return _headerView;
}
@end
