//
//  QXUserInfoController.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#define kBottomBarH 49

#import "QXUserInfoController.h"
#import "QXUserInfoCell.h"
#import "ToothManager.h"
#import "QXLoginController.h"
#import "QXNavigationController.h"
#import "QXChangeNameViewController.h"
#import "QXChangeAvatarViewController.h"
#import "STPickerDate.h"
@interface QXUserInfoController ()<UITableViewDelegate,UITableViewDataSource,STPickerDateDelegate>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic,strong) STPickerDate *pickerDate;
@end

@implementation QXUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑个人信息";
    self.view.backgroundColor = UIColorHex(0xffffff);
    [self setupTableView];
    [self setupBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:ChangeUserInfoNoti object:nil];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight - kBottomBarH) style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTableViewColor;
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
}
- (void)setupBottomView {

    UIButton *loginoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - kBottomBarH - kTabBarHeight + 49, ScreenWidth, kBottomBarH)];
    [loginoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:UIColorHex(0x0060f0) forState:UIControlStateNormal];
    loginoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginoutBtn addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginoutBtn];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QXUserInfoCell *cell = [QXUserInfoCell cellWithTableView:tableView];
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"修改头像";
            [cell.avatarImgView setImageWithURL:[NSURL URLWithString:user.head] placeholder:[UIImage imageNamed:@"mylogin-tx"]];
        }
        if (indexPath.row == 1) {
            cell.leftLabel.text = @"修改昵称";
            cell.rightLabel.text = user.cname;
            cell.lineView.hidden = YES;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"性别";
            if ([user.sex integerValue] == 1) {
                cell.rightLabel.text = @"女";
            } else{
                cell.rightLabel.text = @"男";
            }
        }
        if (indexPath.row == 1) {
            cell.leftLabel.text = @"生日";
            cell.rightLabel.text = user.birthday;
            cell.lineView.hidden = YES;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QXChangeAvatarViewController *avatarVC = [[QXChangeAvatarViewController alloc] init];
            [self.navigationController pushViewController:avatarVC animated:YES];
        }
        if (indexPath.row == 1) {
            QXChangeNameViewController *changeNameVC = [[QXChangeNameViewController alloc] init];
            [self.navigationController pushViewController:changeNameVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self changeUserSexType];
        }
        if (indexPath.row == 1) {
            [self changeUserBirthday];
        }
    }
}

#pragma mark - 修改生日
- (void)changeUserBirthday {
    [self.pickerDate show];
}
#pragma mark -STPickerDateDelegate
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *birthDate = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    
    //美国时间
//    NSDate *birthDat = [formatter dateFromString:birthDate];
//
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:birthDat];
//    //本地时间
//    NSDate *nowDate = [birthDat dateByAddingTimeInterval:interval];
//
//    NSTimeInterval birthInt = [nowDate timeIntervalSince1970];
    
    
    [self saveInfoWithDic:@{@"birthday":birthDate}];
    
    if (birthDate) {
        JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
        userInfo.birthday = birthDate;
        [JZUserInfo archiveObject:userInfo];
        [self.tableView reloadData];
    }
}

- (STPickerDate *)pickerDate {
    if (!_pickerDate) {
        _pickerDate = [[STPickerDate alloc]init];
        _pickerDate.frame = self.view.bounds;
        _pickerDate.contentMode = STPickerContentModeBottom;
        _pickerDate.delegate = self;
        [_pickerDate setYearLeast:1900];
        _pickerDate.heightPickerComponent = 35;
    }
    return _pickerDate;
}

#pragma mark - 修改性别
- (void)changeUserSexType {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
        userInfo.sex = @"0";
        [JZUserInfo archiveObject:userInfo];
        [weakSelf saveInfoWithDic:@{@"sex":@(0)}];
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *womenAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
        userInfo.sex = @"1";
        [JZUserInfo archiveObject:userInfo];
        [weakSelf saveInfoWithDic:@{@"sex":@(1)}];
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:manAction];
    [alertController addAction:womenAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 保存数据
- (void)saveInfoWithDic:(NSDictionary *)dic {
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (ISNULL(user.userId)) {
        return;
    }
    //保存数据
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"uid" : user.userId}];
    
    for (NSString *key in dic.allKeys) {
        params[key] = dic[key];
    }
    [[UFHttpRequest defaultHttpRequest] postRequest:API_USER_UPDATE alertView:nil parameters:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 退出登录
- (void)loginout {
    __weak typeof(self)weakSelf = self;
    [ToothManager loginOutEMChatSuccess:^{
        [weakSelf loginOutSuccess];
    } failture:^(HError *error) {
        
    }];
}
- (void)loginOutSuccess {
    [JZUserInfo archiveObject:nil];//清除用户信息
    QXLoginController *loginVC = [[QXLoginController alloc] init];
    QXNavigationController *navi = [[QXNavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
}


- (void)updateUserInfo {
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
