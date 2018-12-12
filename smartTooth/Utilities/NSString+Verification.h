//
//  NSString+Verification.h
//  JiangDiet
//
//  Created by yanghengzhan on 2016/10/20.
//  Copyright © 2016年 yanghengzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verification)

//验证手机号
- (BOOL)validatePhoneNumber;

//验证密码
- (BOOL)validatePassword;

//用户名验证
- (BOOL)validateUser;

@end
