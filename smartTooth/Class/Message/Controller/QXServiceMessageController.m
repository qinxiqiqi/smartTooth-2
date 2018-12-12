//
//  QXServiceMessageController.m
//  SmartTooth
//
//  Created by qinxi on 2018/11/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXServiceMessageController.h"

@interface QXServiceMessageController ()

@end

@implementation QXServiceMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置访客信息
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    HVisitorInfo *info = [[HVisitorInfo alloc] init];
    info.nickName = user.cname;
    info.phone = user.phone;
    self.visitorInfo = info;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
