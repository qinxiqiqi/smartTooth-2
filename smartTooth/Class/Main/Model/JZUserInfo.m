//
//  JZUserInfo.m
//  JiangDiet
//
//  Created by zhuanghua on 2018/2/5.
//  Copyright © 2018年 JiuZhou. All rights reserved.
//

#import "JZUserInfo.h"
#import <objc/message.h>
#import <objc/runtime.h>


static JZUserInfo *userinfo;

@implementation JZUserInfo

+(JZUserInfo *)Share
{
    if (userinfo == nil) {
        static dispatch_once_t once_t;
        dispatch_once(&once_t, ^{
            userinfo = [[self alloc] init];
        }) ;
    }
    return userinfo;
}

-(id)init
{
    self = [super init];
    if (self) {
        //        self.ArrImage = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0 ;
    objc_property_t *property_arr = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t property = property_arr[i];
        const char* keyname = property_getName(property);
        NSString *keyN = [NSString stringWithUTF8String:keyname];
        id value = [self valueForKey:keyN];
        [aCoder encodeObject:value forKey:keyN];
    }
    free(property_arr);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        unsigned int count = 0 ;
        objc_property_t *property_arr = class_copyPropertyList([self class], &count);
        for (int i=0; i<count; i++) {
            objc_property_t property = property_arr[i];
            const char* keyname = property_getName(property);
            NSString *keyN = [NSString stringWithUTF8String:keyname];
            id value = [aDecoder decodeObjectForKey:keyN];
            [self setValue:value forKey:keyN];
        }
        free(property_arr);
    }
    return self;
}

+(NSString *)SavePath
{
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    // 获得Documents全路径
    NSString * path = [doc stringByAppendingPathComponent:@"JZUserInfo"]; // 获取文件的全路径
    return path;
}

#pragma mark 归档模型对象
+(void)archiveObject:(JZUserInfo *)user
{
    [NSKeyedArchiver  archiveRootObject:user toFile:[self SavePath]]; // 将对象归档
}

#pragma mark 读取模型对象
+(JZUserInfo *)unarchiveObject
{
    return [NSKeyedUnarchiver  unarchiveObjectWithFile:[self SavePath]];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId":@"id"};
}

@end
