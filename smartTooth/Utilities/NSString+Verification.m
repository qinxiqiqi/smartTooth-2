//
//  NSString+Verification.m
//  JiangDiet
//
//  Created by yanghengzhan on 2016/10/20.
//  Copyright © 2016年 yanghengzhan. All rights reserved.
//

#import "NSString+Verification.h"

@implementation NSString (Verification)

- (BOOL)validatePhoneNumber{
 
//    NSString *number = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|16[0-9]|14[57])[0-9]{8}$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", number];
//    return ([numberPre evaluateWithObject:self] && self.length == 11);
    NSString *MOBILE =@"^(1[3-9][0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ( [regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

//6-12位数字，字母加下划线
- (BOOL)validatePassword{
    
    NSString *number = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9_]{6,12}";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [numberPre evaluateWithObject:self];;
}

- (BOOL)validateUser{
    
    NSString *number = @"^[0-9a-zA-Z_]{6,12}";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [numberPre evaluateWithObject:self];;
}

@end
