//
//  QXLocationViewController.m
//  NaHao
//
//  Created by NIT on 2017/10/31.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import "QXLocationViewController.h"
#import "QXLocationCell.h"
#import "QXSearchBar.h"
#import "CityModel.h"
#import "QXCityCell.h"
#import "JZLocationHeaderView.h"
#import "Pinyin.h"
//#import "QXNearViewController.h"
@interface QXLocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JZLocationHeaderViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableDictionary *cityDict;//城市数据分好以后的
@property (nonatomic, strong) NSMutableArray *indexArray;//下标
@property (nonatomic, strong) JZLocationHeaderView *headerView;
@end

@implementation QXLocationViewController
- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"切换城市";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    [self initData];
    [self setupNaviView];
}
- (void)setupNaviView {
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    naviBar.backgroundColor = UIColorHex(0xffffff);
    [self.view addSubview:naviBar];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 54, 44)];
    [backBtn setImage:[UIImage imageNamed:@"close-black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 200, 44)];
    titleLabel.centerX = naviBar.centerX;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"切换城市";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = UIColorHex(0x333333);
    [naviBar addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, naviBar.height - 1, ScreenWidth, 1)];
    lineView.backgroundColor = kLineColor;
    [naviBar addSubview:lineView];
}
- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
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
- (void)initData
{
    __weak typeof(self)weakSelf = self;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_LOCATION_CITYLIST alertView:nil parameters:nil success:^(id  _Nullable responseObject) {
        if (ISNULL(responseObject)) {
            return ;
        }
        NSDictionary *data = responseObject[@"data"];
        if (ISNULL(data)) {
            return;
        }
        self.hotArray = [CityModel mj_objectArrayWithKeyValuesArray:data[@"hotarea"]];
        
        self.headerView.hotArray = self.hotArray;
        self.headerView.height = self.headerView.headerHeight;
        
        NSArray *tempArray = [CityModel mj_objectArrayWithKeyValuesArray:data[@"area"]];
        [weakSelf convertCity:tempArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)convertCity:(NSArray *)tempArray {
    self.cityDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < tempArray.count;i++) {
        CityModel *model = tempArray[i];
        NSString *firstChar = [model.pinyin substringToIndex:1];
        if ([_cityDict.allKeys containsObject:firstChar]) {
            NSMutableArray *array = _cityDict[firstChar];
            if (array) {
                if (![array containsObject:model]) {
                    [array addObject:model];
                }
            } else {
                array = [NSMutableArray arrayWithObject:model];
                [_cityDict setObject:array forKey:firstChar];
            }
        } else {
            [self.indexArray addObject:firstChar];
            NSMutableArray *array = [NSMutableArray arrayWithObject:model];
            [_cityDict setObject:array forKey:firstChar];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *citys = [self.cityDict valueForKey:self.indexArray[section]];
    return citys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        QXLocationCell *cell = [QXLocationCell cellWithTableView:tableView];
//        JZUserInfo *user = [JZUserInfo unarchiveObject];
//        cell.currentLocation = user.location;
//        return cell;
//    }
    NSArray *citys = [self.cityDict valueForKey:self.indexArray[indexPath.section]];
    CityModel *model = citys[indexPath.row];
    QXCityCell *cell = [QXCityCell cellWithTableView:tableView];
    cell.cityLabel.text = model.city_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = UIColorHex(0xf5f5f5);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, headerView.height)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorHex(0xb2b4be);
    label.text = self.indexArray[section];
    [headerView addSubview:label];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *citys = [self.cityDict valueForKey:self.indexArray[indexPath.section]];
    CityModel *model = citys[indexPath.row];
    [self selectCity:model.city_name];
}

//快速索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.indexArray copy];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - 选择城市
- (void)locationHeaderView:(JZLocationHeaderView *)headerView didSelectCity:(NSString *)cityName
{
    [self selectCity:cityName];
}
- (void)selectCity:(NSString *)cityName {
    if (self.didSelectCity) {
        self.didSelectCity(cityName);
    }
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"historyCity"] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    if (![array containsObject:cityName]) {
        [array addObject:cityName];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:@"historyCity"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (JZLocationHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JZLocationHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        _headerView.delegate = self;
    }
    return _headerView;
}

@end
