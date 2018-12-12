//
//  QXLabelListView.h
//  SmartTooth
//
//  Created by qinxi on 2018/10/26.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXLabelListView : UIView
@property (nonatomic, strong) NSArray *labelList;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat viewHeight;//总高
+ (CGFloat)getHeightWithLabelList:(NSArray *)labelList leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin totalWidth:(CGFloat)totalWidth;
@end

NS_ASSUME_NONNULL_END
