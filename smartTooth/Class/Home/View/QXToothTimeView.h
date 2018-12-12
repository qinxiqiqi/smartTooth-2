//
//  QXToothTimeView.h
//  smartTooth
//
//  Created by qinxi on 2018/11/8.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXToothTimeView : UIView
@property (nonatomic, copy) void(^toothTimeSelect)(NSInteger selectTime);
@end

NS_ASSUME_NONNULL_END
