//
//  QXToothStyleView.m
//  smartTooth
//
//  Created by qinxi on 2018/11/8.
//  Copyright © 2018年 ttzx. All rights reserved.
//
#define kBaseTag 2000

#import "QXToothStyleView.h"

@interface QXToothStyleView()
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation QXToothStyleView

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
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
    label.text = @"刷牙模式选择";
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
        make.top.equalTo(label.mas_bottom).offset(WidthScale6(10));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    NSArray *imageArray = @[@"qingjieStyle",@"meibaiStyle",@"anmoStyle"];
    CGFloat controlW = WidthScale6(104);
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateHighlighted];
        btn.tag = kBaseTag + i;
        btn.layer.cornerRadius = WidthScale6(8);
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(styleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(WidthScale6(20) + i * (controlW + WidthScale6(10)));
            make.top.equalTo(lineView.mas_bottom).offset(WidthScale6(30));
            make.width.mas_offset(controlW);
            make.height.mas_offset(WidthScale6(140));
        }];
        
        UIButton *selectBtn = [[UIButton alloc] init];
        [self.btnArray addObject:selectBtn];
        [selectBtn setImage:[UIImage imageNamed:@"style_unselect"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"style_select"] forState:UIControlStateSelected];
        [self addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_left);
            make.top.equalTo(btn.mas_top);
            make.width.mas_offset(WidthScale6(30));
            make.height.mas_offset(WidthScale6(30));
        }];
        
    }
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    UIButton *selectBtn = self.btnArray[user.smode];
    selectBtn.selected = YES;
    self.selectBtn = selectBtn;
}

- (void)styleBtnClicked:(UIButton *)sender {
    NSInteger tag = sender.tag - kBaseTag;
    UIButton *currentBtn = self.btnArray[tag];
    if (self.selectBtn != currentBtn) {
        self.selectBtn.selected = NO;
        currentBtn.selected = YES;
        self.selectBtn = currentBtn;
    }
    if (self.toothStyleSelect) {
        self.toothStyleSelect(tag);
    }
}

@end
