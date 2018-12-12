//
//  QXZhiliaoController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXZhiliaoController.h"
#import "QXZhiliaoHeaderView.h"
#import "QXZhiliaoActiveCell.h"
#import "QXZhiliaoClinicCell.h"
#import "QXDoctroListController.h"
#import "QXTitleImageBtn.h"
#import "QXSearchBar.h"
#import "QXLocationViewController.h"
#import "QXDoctorPersonController.h"
#import "QXClinicHomeController.h"
#import "LocationManager.h"

#import "QXClinicModel.h"
#import "CityModel.h"
#import "ToothManager.h"
#import <Masonry.h>

#import "JDAlertCustom.h"
@interface QXZhiliaoController ()<UITableViewDelegate,UITableViewDataSource,QXZhiliaoHeaderViewDelegate,QXZhiliaoClinicCellDelegate,UITextFieldDelegate>
{
    NSInteger _page;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) QXZhiliaoHeaderView *headerView;
@property (nonatomic, weak) QXTitleImageBtn *locationBtn;
@property (nonatomic, weak) QXSearchBar *searchBar;
@property (nonatomic, weak) UIButton *coverView;//蒙版

@property (nonatomic, strong) NSMutableArray *clinicArray;
@end

@implementation QXZhiliaoController

- (NSMutableArray *)clinicArray
{
    if (!_clinicArray) {
        _clinicArray = [NSMutableArray array];
    }
    return _clinicArray;
}

- (QXZhiliaoHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[QXZhiliaoHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 380)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNaviView];
    [self setupTableView];
    
    [self initData];
}
- (void)setupNaviView {
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, ScreenWidth, kNavigationBarHeight - kStatusBarHeight)];
    //JZUserInfo *user = [JZUserInfo unarchiveObject];
    NSString *showCity = [self showCity];
    QXTitleImageBtn *locationBtn = [[QXTitleImageBtn alloc]initWithTitle:showCity titleFont:[UIFont systemFontOfSize:17] titleColor:[UIColor whiteColor] imageName:@"position_arrow" style:TitleImageBtnStyleRightImage leftMargin:0 centerMargin:3 rightMargin:0 frame:CGRectMake(7, 0, 0, naviView.height) isAutoWidth:YES];
    self.locationBtn = locationBtn;
    [locationBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:locationBtn];
    
    QXSearchBar *searchBar = [[QXSearchBar alloc] initWithStyle:SearchBarStyleLeft frame:CGRectMake(locationBtn.right + 20, naviView.height - 8 - 28, naviView.width - locationBtn.width - 40, 28)];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = searchBar.height/2;
    searchBar.layer.masksToBounds = YES;
    [naviView addSubview:searchBar];
    
    self.navigationItem.titleView = naviView;
}
- (NSString *)showCity {
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    for (CityModel *model in [ToothManager shareManager].cityList) {
        if ([user.location isEqualToString:model.city_name]) {
            return user.location;
        }
    }
    [[JDAlertCustom currentView] alertViewWithMessage:@"您的城市暂未开通！"];
    return @"无锡市";
}
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }
    return self.clinicArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        QXZhiliaoActiveCell *cell = [QXZhiliaoActiveCell cellWithTableView:tableView];
//        return cell;
//    }
    QXZhiliaoClinicCell *cell = [QXZhiliaoClinicCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.clinicModel = self.clinicArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return kActiveCollectionItemH;
//    }
    return ScreenWidth * 9 / 16 + kclinicCollectionItemH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 + 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineView.backgroundColor = UIColorHex(0xf2f2f2);
    [headerView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, headerView.height - 10)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColorHex(0x333333);
    [headerView addSubview:titleLabel];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, 0, 1, 12)];
    verticalLine.backgroundColor = kLineColor;
    verticalLine.centerY = titleLabel.centerY;
    [headerView addSubview:verticalLine];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.right + 10, 10, 200, headerView.height - 10)];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = UIColorHex(0x979797);
    [headerView addSubview:descLabel];
    
//    if (section == 0) {
//        titleLabel.text = @"精彩活动";
//        descLabel.text = @"参加活动，发现生活新乐趣";
//    } else {
        titleLabel.text = @"精选诊所";
        descLabel.text = @"绝对不会错的牙医诊所";
//    }
    return headerView;
}


#pragma mark - 点击快速问医生
- (void)headerView:(QXZhiliaoHeaderView *)headerView linkDoctroAction:(DoctorHeaderType)linkType
{
    NSString *doctorType = @"";
    switch (linkType) {
        case DoctorHeaderTypeQuick:
            doctorType = @"own";
            break;
        case DoctorHeaderTypeFamous:
            doctorType = @"famous";
            break;
        case DoctorHeaderTypeFree:
            doctorType = @"duty";
            break;
        case DoctorHeaderTypeBaya:
            doctorType = @"eaef1435fece4085bca7a03eee846e15";
            break;
        case DoctorHeaderTypeBuya:
            doctorType = @"eaef1435fece4085bca7a03eee846e16";
            break;
        case DoctorHeaderTypeErya:
            doctorType = @"eaef1435fece4085bca7a03eee846e10";
            break;
        case DoctorHeaderTypeXiya:
            doctorType = @"eaef1435fece4085bca7a03eee846e14";
            break;
        case DoctorHeaderTypeQuchi:
            doctorType = @"eaef1435fece4085bca7a03eee846e11";
            break;
        case DoctorHeaderTypeMeibai:
            doctorType = @"eaef1435fece4085bca7a03eee846e13";
            break;
        case DoctorHeaderTypeZhongzhi:
            doctorType = @"eaef1435fece4085bca7a03eee846e17";
            break;
        case DoctorHeaderTypeJiaozheng:
            doctorType = @"eaef1435fece4085bca7a03eee846e12";
            break;
        
    }
    QXDoctroListController *docListVC = [[QXDoctroListController alloc] init];
    docListVC.doctorType = doctorType;
    docListVC.city = self.locationBtn.customTitleLabel.text;
    [self.navigationController pushViewController:docListVC animated:YES];
}

#pragma mark - 选择定位
- (void)locationBtnClicked:(UIButton *)sender {
    QXLocationViewController *locationVC = [[QXLocationViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    locationVC.didSelectCity = ^(NSString *city) {
        weakSelf.locationBtn.customTitleLabel.text = city;
        weakSelf.searchBar.left = weakSelf.locationBtn.right + 20;
        weakSelf.searchBar.width = ScreenWidth - weakSelf.locationBtn.width - 40;
        [weakSelf getClinicList];
    };
    [self presentViewController:locationVC animated:YES completion:nil];
}

#pragma mark - clinicCell delegate
#pragma mark - 点击诊所
- (void)clinicCell:(QXZhiliaoClinicCell *)cell didClickClinicBtn:(QXClinicModel *)clinic
{
    QXClinicHomeController *clinicHomeVC = [[QXClinicHomeController alloc] init];
    clinicHomeVC.clinicModel = clinic;
    [self.navigationController pushViewController:clinicHomeVC animated:YES];
}
#pragma mark - 点击医生
- (void)clinicCell:(QXZhiliaoClinicCell *)cell didClickDoctorBtn:(QXDoctorModel *)doctor
{
    QXDoctorPersonController *doctorVC = [[QXDoctorPersonController alloc] init];
    doctorVC.doctorModel = doctor;
    [self.navigationController pushViewController:doctorVC animated:YES];
}

//开始定位，获取用户当前城市
- (void)startLocation
{
    LocationManager *manager = [LocationManager shareManager];
    [manager beginLocation];//开启定位
    __weak typeof(self)weakSelf = self;
    manager.locationGet = ^(NSString *location,NSString *detail) {//获取位置
        NSString *city = [location substringToIndex:location.length];
        JZUserInfo *user = [JZUserInfo unarchiveObject];
        user.location = city;
        [JZUserInfo archiveObject:user];
        weakSelf.locationBtn.customTitleLabel.text = city;
        weakSelf.searchBar.left = weakSelf.locationBtn.right + 20;
        weakSelf.searchBar.width = ScreenWidth - weakSelf.locationBtn.width - 40;
    };
}

#pragma mark - 搜索

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.coverView removeFromSuperview];
        [self getClinicList];
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIButton *coverView = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.coverView = coverView;
    [coverView addTarget:self action:@selector(keyboardDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverView];
}
- (void)keyboardDismiss {
    [self.coverView removeFromSuperview];
    [self.searchBar resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.coverView removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self keyboardDismiss];
}



#pragma mark - 请求接口
- (void)initData {
    [self getClinicList];
}
- (void)getClinicList {
    _page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //JZUserInfo *user = [JZUserInfo unarchiveObject];
    param[@"page"] = @(_page);
    if (self.locationBtn.customTitleLabel.text.length > 0) {
        param[@"city"] = self.locationBtn.customTitleLabel.text;
    } else {
        param[@"city"] = @"无锡市";
    }
    param[@"cname"] = self.searchBar.text;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_CLINIC_LIST alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.clinicArray removeAllObjects];
            self.clinicArray = [QXClinicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
