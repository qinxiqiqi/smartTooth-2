//
//  QXLocationViewController.h
//  NaHao
//
//  Created by NIT on 2017/10/31.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXLocationViewController : UIViewController
@property (nonatomic, copy) void(^didSelectCity)(NSString *);
@end
