//
//  QXToothTimeView.m
//  smartTooth
//
//  Created by qinxi on 2018/11/8.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#define kBaseTag 5000

#import "QXToothTimeView.h"

@interface QXToothTimeView()
@property (nonatomic, weak) UILabel *minuteLabel;
@property (nonatomic, weak) UIImageView *minuteImgView;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation QXToothTimeView

- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"刷牙时长";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorHex(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_offset(200);
        make.height.mas_offset(WidthScale6(20));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(0x0061ee);
    lineView.layer.cornerRadius = 2;
    lineView.layer.masksToBounds = YES;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(30);
        make.height.mas_offset(WidthScale6(4));
        make.top.equalTo(label.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *minuteLabel = [[UILabel alloc] init];
    self.minuteLabel = minuteLabel;
    minuteLabel.text = @"2分钟";
    minuteLabel.font = [UIFont systemFontOfSize:24];
    minuteLabel.textColor = UIColorHex(0x0060f0);
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:minuteLabel];
    [minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(WidthScale6(30));
        make.width.mas_offset(200);
        make.height.mas_offset(WidthScale6(33));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = UIColorHex(0xe5e5e5);
    [self addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(minuteLabel.mas_bottom).offset(WidthScale6(37));
        make.right.equalTo(self).offset(-20);
        make.height.mas_offset(WidthScale6(4));
    }];
    
    NSArray *textArray = @[@"2分钟",@"2.5分钟",@"3分钟",@"3.5分钟"];
    for (int i = 0; i < textArray.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorHex(0xffffff);
        view.layer.cornerRadius = 6;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = UIColorHex(0xe5e5e5).CGColor;
        view.layer.borderWidth = 1;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayLine.mas_left).offset(WidthScale6(40) + i * WidthScale6(67));
            make.centerY.equalTo(grayLine.mas_centerY);
            make.width.mas_offset(12);
            make.height.mas_offset(12);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = kBaseTag + i;
        [btn addTarget:self action:@selector(minuteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(minuteLabel.mas_bottom);
            make.width.mas_offset((ScreenWidth - 40) / 4);
            make.height.mas_offset(78);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = textArray[i];
        label.textColor = UIColorHex(0xb2b4be);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labelArray addObject:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(grayLine.mas_bottom).offset(14);
            make.centerX.equalTo(view.mas_centerX);
            make.height.mas_offset(17);
            make.width.mas_offset(100);
        }];
    }
    UIImageView *minuteImgView = [[UIImageView alloc] init];
    self.minuteImgView = minuteImgView;
    minuteImgView.image = [UIImage imageNamed:@"time_select"];
    minuteImgView.layer.cornerRadius = 9;
    minuteImgView.layer.masksToBounds = YES;
    [self addSubview:minuteImgView];
    [minuteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(grayLine.mas_left).offset(WidthScale6(40));
        make.centerY.equalTo(grayLine.mas_centerY);
        make.width.mas_offset(18);
        make.height.mas_offset(18);
    }];
    
    NSInteger smodeTime = 0;
    NSInteger index = 0;
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (user.smode == 0) {
        smodeTime = user.smodetime0;
    } else if (user.smode == 1) {
        smodeTime = user.smodetime1;
    } else if (user.smode == 2) {
        smodeTime = user.smodetime2;
    }
    if (smodeTime >= 4) {
        index = smodeTime - 4;
    }
    [self updateTimeState:index];
}
- (void)updateTimeState:(NSInteger)index {
    if (self.selectIndex) {
        UILabel *preLabel = self.labelArray[self.selectIndex];
        preLabel.textColor = UIColorHex(0xb2b4be);
    }
    UILabel *currentLabel = self.labelArray[index];
    currentLabel.textColor = UIColorHex(0x0060f0);
    self.minuteLabel.text = currentLabel.text;
}


- (void)minuteBtnClicked:(UIButton *)sender {
    NSInteger tag = sender.tag - kBaseTag;
    
    NSInteger second = 0;
    self.selectIndex = tag;
    switch (tag) {
        case 0:
            second = 120;
            break;
        case 1:
            second = 150;
            break;
        case 2:
            second = 180;
            break;
        case 3:
            second = 210;
            break;
    }
    if (self.toothTimeSelect) {
        self.toothTimeSelect(second/30);
    }
    [self updateTimeState:tag];
    [UIView animateWithDuration:0.3 animations:^{
        self.minuteImgView.left = 20 + WidthScale6(40) + tag * WidthScale6(67) - 3;
    }];
}

@end
