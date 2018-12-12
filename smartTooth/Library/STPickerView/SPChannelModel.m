//
//  SPChannelModel.m
//  JiangDiet
//
//  Created by 蓝现 on 2017/5/12.
//  Copyright © 2017年 yanghengzhan. All rights reserved.
//

#import "SPChannelModel.h"

@implementation SPChannelModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"channelId":@"id"
             };
}
@end
