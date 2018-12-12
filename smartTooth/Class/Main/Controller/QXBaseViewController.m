//
//  QXBaseViewController.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/8.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXBaseViewController.h"

@interface QXBaseViewController ()

@end

@implementation QXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTopMargin:(CGFloat)topMargin
{
    _topMargin = topMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(topMargin, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topMargin, 0, 0, 0);
}
@end
