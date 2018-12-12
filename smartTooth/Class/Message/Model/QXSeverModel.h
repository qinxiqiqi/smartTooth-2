//
//  QXSeverModel.h
//  smartTooth
//
//  Created by qinxi on 2018/11/6.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXSeverModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, assign) BOOL isWork;
@end

NS_ASSUME_NONNULL_END
