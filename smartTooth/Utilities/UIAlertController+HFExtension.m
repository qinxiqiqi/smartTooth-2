//
//  UIAlertController+HFExtension.m
//  MeiX
//
//  Created by joyman04 on 2017/1/12.
//  Copyright © 2017年 wangyuqian. All rights reserved.
//

#import "UIAlertController+HFExtension.h"

@implementation UIAlertController (HFExtension)

+ (instancetype)alertViewTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitle handler:(void(^)(UIAlertAction *action))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle != nil) {
        [alert addCancelActionTargetTitle:cancelButtonTitle action:handler];
    }
    if (otherButtonTitle != nil) {
        [alert addActionTargetTitle:otherButtonTitle color:[UIColor darkGrayColor] action:handler];
    }
    return alert;
}

+ (instancetype)actionSheetTitle:(NSString*)title message:(NSString*)message actionTargetTitles:(NSArray<NSString*>*)actionTargetTitles handler:(void(^)(UIAlertAction *action, NSInteger index))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title isEqualToString:@""] ? nil : title message:[message isEqualToString:@""] ? nil : message preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addCancelActionTargetTitle:@"取消" action:^(UIAlertAction * _Nullable action) {
        handler(action,-1);
    }];
    for (NSString* title in actionTargetTitles) {
        __block NSInteger weakIndex = [actionTargetTitles indexOfObject:title];
        [alert addActionTargetTitle:title color:[UIColor darkGrayColor] action:^(UIAlertAction * _Nullable action) {
            handler(action,weakIndex);
        }];
    }
    return alert;
}

- (void)addActionTargetTitle:(NSString *)title color:(UIColor *)color action:(void(^)(UIAlertAction *action))actionTarget {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:actionTarget];
    if (color != nil) {
        [action setValue:color forKey:@"_titleTextColor"];
    }
    [self addAction:action];
}

- (void)addCancelActionTargetTitle:(NSString *)title action:(void(^)(UIAlertAction *action))actionTarget {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title == nil ? @"确定" : title style:UIAlertActionStyleCancel handler:actionTarget];
    [action setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    [self addAction:action];
}

@end
