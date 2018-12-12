//
//  QXDoctorPersonController.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/16.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXDoctorPersonController.h"
#import "QXDoctoPersonHeader.h"
#import "QXDoctorServeCell.h"
#import "QXClinicHomeController.h"
#import <WebKit/WebKit.h>
#import "QXMapController.h"
#import "EaseConversationListViewController.h"
#import "QXDoctorModel.h"
#import "QXClinicModel.h"

#import "QXDoctorWebController.h"
#import "QXRecomenController.h"

#import "SPPageMenu.h"
@interface QXDoctorPersonController ()<QXDoctoPersonHeaderDelegate,WKNavigationDelegate,SPPageMenuDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) QXDoctoPersonHeader *headerView;
@property (nonatomic, assign) CGRect originalHeaderImgRect;
//导航栏
@property (nonatomic, weak) UIView *naviBar;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *backItem;

@property (nonatomic, strong) UIScrollView *scrollView;
//滑块
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, assign) CGFloat lastPageMenuY;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGFloat headerTopInset;

@property (strong, nonatomic) WKWebView *callWebView;

@end

@implementation QXDoctorPersonController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setupNaviBar];
    [self getDoctorDetailData];
    //拨打电话的
    self.callWebView = [[WKWebView alloc] init];
    _callWebView.navigationDelegate = self;
    [self.view addSubview:_callWebView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.lastPageMenuY = self.headerView.headerHeight;
    
    // 添加一个全屏的scrollView
    [self.view addSubview:self.scrollView];
    // 添加头部视图
    [self.view addSubview:self.headerView];
    // 添加悬浮菜单
    [self.view addSubview:self.pageMenu];
    self.headerTopInset = _pageMenu.bottom;
    // 添加2个子控制器
    QXDoctorWebController *serverListVC = [[QXDoctorWebController alloc] init];
    serverListVC.requestUrl = self.doctorModel.durl;
    serverListVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    serverListVC.topMargin = self.pageMenu.bottom;
    QXRecomenController *recommenVC = [[QXRecomenController alloc] init];
    [self addChildViewController:serverListVC];
    [self addChildViewController:recommenVC];
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subScrollViewDidScroll:) name:@"ChildScrollViewDidScrollNSNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:@"ChildScrollViewRefreshStateNSNotification" object:nil];
}

- (void)setupNaviBar {
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    naviBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:naviBar];
    
    UIView *backView = [[UIView alloc] initWithFrame:naviBar.bounds];
    self.naviBar = backView;
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.f;
    [naviBar addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, kStatusBarHeight, ScreenWidth - 88, 44)];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.doctorModel.name;
    titleLabel.textColor = [UIColor whiteColor];
    [naviBar addSubview:titleLabel];
    titleLabel.hidden = YES;
    
    UIButton *backItem = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 40, 44)];
    self.backItem = backItem;
    [backItem setImage:[UIImage imageNamed:@"white-back-black"] forState:UIControlStateNormal];
    [backItem setImage:[UIImage imageNamed:@"back-black"] forState:UIControlStateSelected];
    [backItem addTarget:self action:@selector(backItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backItem];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, kStatusBarHeight, 40, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"share-white"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    //[naviBar addSubview:rightBtn];
}

#pragma mark - scrollView delegate

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self changeColorWithOffsetY:scrollView.contentOffset.y];
    
    QXBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.tableView.contentSize.height < ScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.tableView setContentOffset:CGPointMake(0, -(weakSelf.headerView.height + weakSelf.pageMenu.height)) animated:YES];
        }
    });
}
#pragma mark - 通知
// 子控制器上的scrollView已经滑动的代理方法所发出的通知(核心)
- (void)subScrollViewDidScroll:(NSNotification *)noti {
    
    // 取出当前正在滑动的tableView
    UIScrollView *scrollingScrollView = noti.userInfo[@"scrollingScrollView"];
    CGFloat offsetDifference = [noti.userInfo[@"offsetDifference"] floatValue];
    CGFloat distanceY;
    NSLog(@"-----------%f",offsetDifference);
    // 取出的scrollingScrollView并非是唯一的，当有多个子控制器上的scrollView同时滑动时都会发出通知来到这个方法，所以要过滤
    QXBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    
    if (scrollingScrollView == baseVc.tableView) {
        
        // 让悬浮菜单跟随scrollView滑动
        CGRect pageMenuFrame = self.pageMenu.frame;
        
        if (pageMenuFrame.origin.y >= 0) {
            // 往上移
            if (offsetDifference > 0 && scrollingScrollView.contentOffset.y+_headerTopInset > 0) {
                
                if (((scrollingScrollView.contentOffset.y+_headerTopInset+self.pageMenu.frame.origin.y)>=_headerView.height) || (scrollingScrollView.contentOffset.y+_headerTopInset < 0)) {
                    // 悬浮菜单的y值等于当前正在滑动且显示在屏幕范围内的的scrollView的contentOffset.y的改变量(这是最难的点)
                    pageMenuFrame.origin.y += -offsetDifference;
                    if (pageMenuFrame.origin.y <= kNavigationBarHeight) {
                        pageMenuFrame.origin.y = kNavigationBarHeight;
                    }
                }
                
            } else { // 往下移
                if((scrollingScrollView.contentOffset.y + self.pageMenu.frame.origin.y + _headerTopInset)<self.headerView.height) {
                    pageMenuFrame.origin.y = -scrollingScrollView.contentOffset.y-_headerTopInset+self.headerView.height;
                    if (pageMenuFrame.origin.y >= self.headerView.height) {
                        pageMenuFrame.origin.y = self.headerView.height;
                    }
                }
            }
        }
        self.pageMenu.frame = pageMenuFrame;
        CGRect headerFrame = self.headerView.frame;
        headerFrame.origin.y = self.pageMenu.frame.origin.y-_headerView.height;
        self.headerView.frame = headerFrame;
        
        // 记录悬浮菜单的y值改变量
        distanceY = pageMenuFrame.origin.y - self.lastPageMenuY;
        self.lastPageMenuY = self.pageMenu.frame.origin.y;
        
        // 让其余控制器的scrollView跟随当前正在滑动的scrollView滑动
        [self followScrollingScrollView:scrollingScrollView distanceY:distanceY];
        [self changeColorWithOffsetY:-self.pageMenu.frame.origin.y+_headerView.height];
    }
}
- (void)changeColorWithOffsetY:(CGFloat)offsetY {
    // 滑出20偏移时开始发生渐变,(kHeaderViewH - 20 - 64)决定渐变时间长度
    if (offsetY > 0) {
        if (offsetY <= (self.originalHeaderImgRect.size.height - kNavigationBarHeight)) {//60是个性签名栏
            if (offsetY > 5) {
                self.naviBar.alpha = offsetY / (self.originalHeaderImgRect.size.height - kNavigationBarHeight);
            } else {
                self.naviBar.alpha = 0;
            }
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.hidden = YES;
            self.backItem.selected = NO;
        } else {
            self.naviBar.alpha = 1.0;
            self.titleLabel.hidden = NO;
            self.titleLabel.textColor = UIColorHex(0x121212);
            self.backItem.selected = YES;
        }
    } else {
        self.naviBar.alpha = 0;
    }
}

- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    QXBaseViewController *baseVc = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        baseVc = self.childViewControllers[i];
        if (baseVc.tableView == scrollingScrollView) {
            continue;
        } else {
            CGPoint contentOffSet = baseVc.tableView.contentOffset;
            contentOffSet.y += -distanceY;
            baseVc.tableView.contentOffset = contentOffSet;
        }
    }
}

- (void)refreshState:(NSNotification *)noti {
    BOOL state = [noti.userInfo[@"isRefreshing"] boolValue];
    // 正在刷新时禁止self.scrollView滑动
    self.scrollView.scrollEnabled = !state;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    QXBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (baseVc.tableView.contentSize.height < ScreenHeight && [baseVc isViewLoaded]) {
            [baseVc.tableView setContentOffset:CGPointMake(0, -(weakSelf.headerView.headerHeight + weakSelf.pageMenu.height)) animated:YES];
        }
    });
}

#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.childViewControllers.count) { return;}
    // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:YES];
    }
    
    QXBaseViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    // 来到这里必然是第一次加载控制器的view，这个属性是为了防止下面的偏移量的改变导致走scrollViewDidScroll
    //targetViewController.isFirstViewLoaded = YES;
    
    targetViewController.view.frame = CGRectMake(ScreenWidth*toIndex, 0, ScreenWidth, ScreenHeight);
    targetViewController.topMargin = self.pageMenu.bottom;
    UIScrollView *s = targetViewController.tableView;
    CGPoint contentOffset = s.contentOffset;
    contentOffset.y = -self.headerView.frame.origin.y-_headerTopInset;
    if (contentOffset.y + _headerTopInset >= _headerView.height) {
        contentOffset.y = _headerView.height-_headerTopInset;
    }
    s.contentOffset = contentOffset;
    [self.scrollView addSubview:targetViewController.view];
}


- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint currenrPoint = [pan translationInView:pan.view];
        CGFloat distanceY = currenrPoint.y - self.lastPoint.y;
        self.lastPoint = currenrPoint;
        
        QXBaseViewController *baseVc = self.childViewControllers[self.pageMenu.selectedItemIndex];
        CGPoint offset = baseVc.tableView.contentOffset;
        offset.y += -distanceY;
        if (offset.y <= -_headerTopInset) {
            offset.y = -_headerTopInset;
        }
        baseVc.tableView.contentOffset = offset;
    } else {
        [pan setTranslation:CGPointZero inView:pan.view];
        self.lastPoint = CGPointZero;
    }
    
}



#pragma mark - HeaderView delegate
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickPhoneAction:(QXClinicModel *)clinic
{
    NSString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",clinic.phone];
    if (!ISNULL(clinic.axphone) && ![clinic.axphone isEqualToString:@""]) {
        str = [[NSMutableString alloc] initWithFormat:@"tel:%@",clinic.axphone];
    }
    [_callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickLocationAction:(QXClinicModel *)clinic
{
    QXMapController *locationVC = [[QXMapController alloc] init];
    locationVC.clinic = clinic;
    locationVC.navigationItem.title = clinic.cname;
    [self.navigationController pushViewController:locationVC animated:YES];
}
- (void)doctorHeader:(QXDoctoPersonHeader *)headerView didClickClinicAction:(QXClinicModel *)clinic
{
    QXClinicHomeController *homeVC = [[QXClinicHomeController alloc] init];
    homeVC.clinicModel = clinic;
    [self.navigationController pushViewController:homeVC animated:YES];
}


- (void)backItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)rightBtnDidClicked {
    EaseConversationListViewController *conversionVC = [[EaseConversationListViewController alloc] init];
    [self.navigationController pushViewController:conversionVC animated:YES];
}


#pragma mark - 请求接口
- (void)getDoctorDetailData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"dcoctor_id"] = self.doctorModel.ID;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_DOCTOR_DETAIL alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            self.doctorModel = [QXDoctorModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.headerView.doctor = self.doctorModel;
            self.headerView.height = self.headerView.headerHeight;
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}

- (SPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, 50) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
        _pageMenu.backgroundColor = [UIColor whiteColor];//背景色
        [_pageMenu setItems:@[@"医生介绍"] selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:14];
        _pageMenu.selectedItemTitleColor = MainColor;
        _pageMenu.unSelectedItemTitleColor = UIColorHex(0x333333);
        _pageMenu.tracker.backgroundColor = UIColorHex(0x0061ee);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
        _pageMenu.itemPadding = 0;
    }
    return _pageMenu;
}

- (QXDoctoPersonHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[QXDoctoPersonHeader alloc] init];
        _headerView.fromType = self.fromType;
        if (self.doctorModel) {
            _headerView.doctor = self.doctorModel;
        }
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _headerView.height = _headerView.headerHeight;
        _headerView.delegate = self;
        self.originalHeaderImgRect = _headerView.topBackImgView.frame;
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [_headerView addGestureRecognizer:panGR];
    }
    return _headerView;
}
@end
