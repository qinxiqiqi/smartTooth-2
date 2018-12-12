//
//  SPChannelModel.h
//  JiangDiet
//
//  Created by 蓝现 on 2017/5/12.
//  Copyright © 2017年 yanghengzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPChannelModel : NSObject

@property (nonatomic,strong) NSString *channelId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL hasChildren;

@end
