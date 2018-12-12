//
//  JDChangeNameViewController.m
//  JiangDiet
//
//  Created by 蓝现 on 2017/1/12.
//  Copyright © 2017年 yanghengzhan. All rights reserved.
//

#import "QXChangeNameViewController.h"
#import "JDAlertCustom.h"

@interface QXChangeNameViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIButton *finishBtn;
@end

@implementation QXChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改昵称";
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    self.finishBtn = btn;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:UIColorHex(0x2f71ff) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorHex(0xd2d5df) forState:UIControlStateSelected];
    [btn setTitleColor:UIColorHex(0xd2d5df) forState:UIControlStateSelected | UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, HeightScale6(25)+64, 200, 13)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGB(183, 183, 183);
    label.text = @"不超过20字符即可";
    [self.view addSubview:label];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom+HeightScale6(15), ScreenWidth, HeightScale6(42))];
    darkView.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:darkView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, HeightScale6(42))];
    self.textField = textField;
    textField.delegate = self;
    [darkView addSubview:textField];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textColor = RGB(51, 51, 51);
    JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
    textField.text = userInfo.cname;
    [textField becomeFirstResponder];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)changeAction:(UIButton *)btn
{
    __weak typeof(self)weakself = self;
    
    NSString *text = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 请输入昵称
    if ([text isEqualToString:@""]) {
        [[JDAlertCustom currentView] alertViewWithMessage:@"昵称不能为空哦~"];
        return;
    }
    
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    if (ISNULL(user)) {
        return;
    }
    //用户昵称
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = user.userId;
    param[@"cname"] = self.textField.text;
    
    [[UFHttpRequest defaultHttpRequest] postRequest:API_USER_UPDATE alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            
            JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
            userInfo.cname = weakself.textField.text;
            [JZUserInfo archiveObject:userInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserInfoNoti object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
// 计算字符串长度
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p ++;
            strlength ++;
        }
        else {
            p ++;
        }
        
    }
    return strlength;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 0) {
        self.finishBtn.selected = NO;
    } else {
        self.finishBtn.selected = YES;
    }
    if (proposedNewLength > 16) {
        return NO;
    }
    return YES;
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
