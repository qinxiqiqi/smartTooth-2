//
//  QXServerMsgListController.m
//  smartTooth
//
//  Created by qinxi on 2018/11/6.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXServerMsgListController.h"
#import "QXSeverModel.h"
#import "QXSeverMsgCell.h"
#import "QXServiceMessageController.h"

@interface QXServerMsgListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *serverList;
@end

@implementation QXServerMsgListController

- (NSMutableArray *)serverList
{
    if (!_serverList) {
        _serverList = [NSMutableArray array];
    }
    return _serverList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self getServerListData];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    [tableView registerNib:[UINib nibWithNibName:@"QXSeverMsgCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QXSeverMsgCell"];
}



- (void)getServerListData {
    NSMutableArray *array = [NSMutableArray array];
    QXSeverModel *model = [[QXSeverModel alloc] init];
    model.nickName = @"坐席超级管理员";
    model.sid = @"xl_personal@126.com";
    [array addObject:model];
    
    QXSeverModel *model1 = [[QXSeverModel alloc] init];
    model1.nickName = @"西庭口腔医院—1号客服";
    model1.sid = @"6677463@qq.com";
    [array addObject:model1];
    
    QXSeverModel *model2 = [[QXSeverModel alloc] init];
    model2.nickName = @"西庭口腔医院—2号客服";
    model2.sid = @"541405444@qq.com";
    [array addObject:model2];
    for (QXSeverModel *model in array) {
        [[[HChatClient sharedClient] leaveMsgManager] getWorkStatusWithToUser:@"15801449477" completion:^(BOOL isWork, NSError *error) {
            if (error == nil) { //成功
                model.isWork = isWork;
            } else {
                model.isWork = NO;
            }
            [self.serverList addObject:model];
            if (array.count == self.serverList.count) {
                [self.tableView reloadData];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serverList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXSeverMsgCell *cell = [QXSeverMsgCell cellWithTableView:tableView];
    cell.model = self.serverList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXServiceMessageController *chatVC = [[QXServiceMessageController alloc] initWithConversationChatter:@"15801449477"]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    QXSeverModel *model = self.serverList[indexPath.row];
    HAgentIdentityInfo *agent = [[HAgentIdentityInfo alloc] initWithValue:model.sid];
    chatVC.agent = agent;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
@end
