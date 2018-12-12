//
//  JZLocationHeaderView.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/11.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "JZLocationHeaderView.h"
#import "CityModel.h"

@interface JZLocationHeaderView()
@property (nonatomic, weak) UIView *currentView;
@property (nonatomic, weak) UIView *historyView;
@property (nonatomic, weak) UIView *hotView;
@property (nonatomic, weak) UILabel *allLabel;
@end

@implementation JZLocationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupCurrentView];
        
        [self setupHistoryView];
        
        [self setupHotView];
    }
    return self;
}

- (void)setupCurrentView {
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    self.currentView = currentView;
    [self addSubview:currentView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(zlLeftMargin, 10, 200, 17)];
    label.text = @"定位城市";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorHex(0x333333);
    [currentView addSubview:label];
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom + 10, (ScreenWidth - 50)/3, 35)];
    locationLabel.text = notNil(user.location);
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = UIColorHex(0x333333);
    locationLabel.layer.borderWidth = 1;
    locationLabel.layer.borderColor = UIColorHex(0xe5e5e5).CGColor;
    locationLabel.backgroundColor = UIColorHex(0xf5f5f5);
    locationLabel.layer.cornerRadius = 2;
    locationLabel.layer.masksToBounds = YES;
    locationLabel.textAlignment = NSTextAlignmentCenter;
    [currentView addSubview:locationLabel];
    currentView.height = locationLabel.bottom;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)];
    locationLabel.userInteractionEnabled = YES;
    [locationLabel addGestureRecognizer:tapGR];
}

- (void)setupHistoryView {
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, _currentView.bottom, ScreenWidth - zlLeftMargin - 20, 0)];
    self.historyView = historyView;
    [self addSubview:historyView];
    
    NSArray *historyCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyCity"];
    CGFloat btnW = (ScreenWidth - 50)/3;
    CGFloat btnH = 35;
    CGFloat margin = 10;
    if (historyCity.count > 0) {
        UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 17)];
        historyLabel.text = @"历史访问";
        historyLabel.font = [UIFont systemFontOfSize:12];
        historyLabel.textColor = UIColorHex(0x333333);
        [historyView addSubview:historyLabel];
        for (int i = 0; i < historyCity.count; i++) {
            NSInteger cols = i / 3;//行数
            NSInteger pols = i % 3;//列数
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pols * btnW + pols * margin, historyLabel.bottom + 10 + cols * btnH + cols * margin, btnW, btnH)];
            label.text = historyCity[i];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = UIColorHex(0x333333);
            label.layer.borderWidth = 1;
            label.layer.borderColor = UIColorHex(0xe5e5e5).CGColor;
            label.backgroundColor = UIColorHex(0xf5f5f5);
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [historyView addSubview:label];
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tapGR];
            historyView.height = CGRectGetMaxY(label.frame);
        }
    } else {
        historyView.frame = CGRectMake(zlLeftMargin, _currentView.bottom, ScreenWidth - zlLeftMargin - 20, 0);
    }
}


- (void)setupHotView {
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(zlLeftMargin, _historyView.bottom, ScreenWidth - zlLeftMargin - 20, 0)];
    self.hotView = hotView;
    [self addSubview:hotView];
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(zlLeftMargin, hotView.bottom + 20, 200, 17)];
    self.allLabel = allLabel;
    allLabel.text = @"所有城市";
    allLabel.font = [UIFont systemFontOfSize:12];
    allLabel.textColor = UIColorHex(0x333333);
    [self addSubview:allLabel];
    
    self.headerHeight = CGRectGetMaxY(allLabel.frame) + 10;
}

- (void)updateHotView {
    CGFloat btnW = (ScreenWidth - 50)/3;
    CGFloat btnH = 35;
    CGFloat margin = 10;
    if (_hotArray.count > 0) {
        UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 17)];
        hotLabel.text = @"热门城市";
        hotLabel.font = [UIFont systemFontOfSize:12];
        hotLabel.textColor = UIColorHex(0x333333);
        [_hotView addSubview:hotLabel];
        for (int i = 0; i < _hotArray.count; i++) {
            NSInteger cols = i / 3;//行数
            NSInteger pols = i % 3;//列数
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pols * btnW + pols * margin, hotLabel.bottom + 10 + cols * btnH + cols * margin, btnW, btnH)];
            CityModel *model = _hotArray[i];
            label.text = model.city_name;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = UIColorHex(0x333333);
            label.layer.borderWidth = 1;
            label.layer.borderColor = UIColorHex(0xe5e5e5).CGColor;
            label.backgroundColor = UIColorHex(0xf5f5f5);
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [_hotView addSubview:label];
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tapGR];
            _hotView.height = CGRectGetMaxY(label.frame);
        }
    } else {
        _hotView.frame = CGRectMake(zlLeftMargin, _historyView.bottom, ScreenWidth - zlLeftMargin - 20, 0);
    }
    self.allLabel.frame = CGRectMake(zlLeftMargin, _hotView.bottom + 20, 200, 17);
    self.headerHeight = CGRectGetMaxY(_allLabel.frame) + 10;
}

- (void)setHotArray:(NSArray *)hotArray
{
    _hotArray = hotArray;
    [self updateHotView];
}



- (void)selectCity:(UITapGestureRecognizer *)tapGR {
    UILabel *label = (UILabel *)tapGR.view;
    if (_delegate && [_delegate respondsToSelector:@selector(locationHeaderView:didSelectCity:)]) {
        [self.delegate locationHeaderView:self didSelectCity:label.text];
    }
}
@end
