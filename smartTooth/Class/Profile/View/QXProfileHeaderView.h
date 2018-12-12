//
//  QXProfileHeaderView.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/2.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXProfileHeaderView;

@protocol QXProfileHeaderViewDelegate <NSObject>
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickEditInfoAction:(UIView *)sender;
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickDoctorDealAction:(UIButton *)sener;
- (void)profileHeaderView:(QXProfileHeaderView *)headerView didClickShopDealAction:(UIButton *)sener;
@end
@interface QXProfileHeaderView : UIView
@property (nonatomic, weak) id<QXProfileHeaderViewDelegate>delegate;
@property (nonatomic, assign) CGFloat headerHeight;
- (void)updateHeaderView;
@end
