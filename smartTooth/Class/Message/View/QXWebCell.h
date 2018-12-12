//
//  JZAudioDetailInfo.h
//  Everyday
//
//  Created by qinxi on 2018/10/17.
//  Copyright © 2018年 Jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol QXWebCellDelegate <NSObject>
- (void)webViewLoadFinish:(CGFloat)webViewHeight;
@end

@interface QXWebCell : UITableViewCell
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) id<QXWebCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
