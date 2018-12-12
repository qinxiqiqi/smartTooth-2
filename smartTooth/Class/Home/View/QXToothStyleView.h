//
//  QXToothStyleView.h
//  smartTooth
//
//  Created by qinxi on 2018/11/8.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface QXToothStyleView : UIView
@property (nonatomic, assign) CGFloat viewHeight;
/** 选择的模式*/
@property (nonatomic, copy) void(^toothStyleSelect)(NSInteger selectStyle);
@end

NS_ASSUME_NONNULL_END
