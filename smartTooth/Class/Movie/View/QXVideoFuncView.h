//
//  QXVideoFuncView.h
//  smartTooth
//
//  Created by qinxi on 2018/11/24.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXVideoFuncView : UIView
@property (nonatomic, copy) void(^didClickRotationAction)(UIButton *sender);
@property (nonatomic, assign) BOOL isShow;

- (void)showView;
- (void)hideView;
@end

NS_ASSUME_NONNULL_END
