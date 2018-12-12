//
//  QXBindingView.h
//  smartTooth
//
//  Created by qinxi on 2018/11/14.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXBindingView : UIView
@property (nonatomic, copy) void(^bindingToothAction)();
@property (nonatomic, copy) void(^flipToVideoAction)();
@end

NS_ASSUME_NONNULL_END
