//
//  QXVideoView.m
//  smartTooth
//
//  Created by qinxi on 2018/11/14.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXVideoView.h"

@interface QXVideoView()
@property (nonatomic, weak) UIButton *button;
@end

@implementation QXVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UIButton *flipBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 50, 0, 50, 40)];
    [flipBtn setTitle:@"翻转" forState:UIControlStateNormal];
    [flipBtn addTarget:self action:@selector(flipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:flipBtn];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, flipBtn.bottom, self.width, self.height - flipBtn.height)];
    [button setTitle:@"看看视频" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bindingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)bindingBtnClicked:(UIButton *)sender {
    if (self.linkVideoAction) {
        self.linkVideoAction();
    }
}
- (void)flipBtnClicked:(UIButton *)sender {
    if (self.flipToBindingAction) {
        self.flipToBindingAction();
    }
}
@end
