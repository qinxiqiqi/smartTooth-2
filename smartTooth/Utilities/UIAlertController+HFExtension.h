//
//  UIAlertController+HFExtension.h
//  MeiX
//
//  Created by joyman04 on 2017/1/12.
//  Copyright © 2017年 wangyuqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (HFExtension)

+ (nonnull instancetype)alertViewTitle:(nullable NSString*)title message:(nullable NSString*)message cancelButtonTitle:(nullable NSString*)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitle handler:(void(^__nullable)(UIAlertAction * _Nullable action))handler;

+ (nonnull instancetype)actionSheetTitle:(nullable NSString*)title message:(nullable NSString*)message actionTargetTitles:(nullable NSArray<NSString*>*)actionTargetTitles handler:(void(^__nullable)(UIAlertAction * _Nullable action, NSInteger index))handler;

- (void)addActionTargetTitle:(nonnull NSString *)title color:(nullable UIColor *)color action:(void(^__nullable)( UIAlertAction * _Nullable action))actionTarget;

- (void)addCancelActionTargetTitle:(nonnull NSString *)title action:(void(^__nullable)(UIAlertAction *_Nullable action))actionTarget;

@end
