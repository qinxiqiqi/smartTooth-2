//
//  QXProfileController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/6.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXProfileController.h"
#import "ToothManager.h"
#import "QXLoginController.h"
#import "QXNavigationController.h"
#import "QXProfileHeaderView.h"
#import "QXProfileCell.h"
#import "QXUserInfoController.h"
@interface QXProfileController ()<UITableViewDelegate,UITableViewDataSource,QXProfileHeaderViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) QXProfileHeaderView *headerView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation QXProfileController
//- (NSArray *)imageArray
//{
//    if (!_imageArray) {
//        _imageArray = [NSArray arrayWithObjects:@"my_yqhy",@"my_lxkf",@"my_gzfwh",@"my_pjwm",nil];
//    }
//    return _imageArray;
//}
//- (NSArray *)titleArray
//{
//    if (!_titleArray) {
//        _titleArray = [NSArray arrayWithObjects:@"邀请好友",@"联系客服",@"关注公众号",@"评价我们", nil];
//    }
//    return _titleArray;
//}
- (NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:@"my_lxkf",nil];
    }
    return _imageArray;
}
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"联系客服",nil];
    }
    return _titleArray;
}

- (QXProfileHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[QXProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        _headerView.height = _headerView.headerHeight;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:ChangeUserInfoNoti object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
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
    tableView.tableHeaderView = self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXProfileCell *cell = [QXProfileCell cellWithTableView:tableView];
    cell.backImgView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth * 120 / 747;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}



#pragma mark - profileHeaderView delegate
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickEditInfoAction:(UIView *)sender
{
    QXUserInfoController *userInfoVC = [[QXUserInfoController alloc] init];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickShopDealAction:(UIButton *)sener
{
    
}
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickDoctorDealAction:(UIButton *)sener
{
    
}

- (void)updateUserInfo {
    [self.headerView updateHeaderView];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
