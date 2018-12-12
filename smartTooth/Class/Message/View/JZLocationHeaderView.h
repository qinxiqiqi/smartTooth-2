//
//  JZLocationHeaderView.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/11.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZLocationHeaderView;

@protocol JZLocationHeaderViewDelegate <NSObject>
- (void)locationHeaderView:(JZLocationHeaderView *)headerView didSelectCity:(NSString *)cityName;
@end

@interface JZLocationHeaderView : UIView
@property (nonatomic, strong) NSArray *hotArray;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, weak) id<JZLocationHeaderViewDelegate>delegate;
@end
