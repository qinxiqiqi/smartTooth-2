//
//  WifiListView.h
//  SmartTooth
//
//  Created by qinxi on 2018/10/29.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WifiListView,QXWifiModel;

@protocol WifiListViewDelegate <NSObject>
- (void)wifiListView:(WifiListView *)wifiView didClickWifi:(QXWifiModel *)wifi;
@end

@interface WifiListView : UIView
@property (nonatomic, weak) id<WifiListViewDelegate>delegate;
@property (nonatomic, strong) NSArray *dataArray;

- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
