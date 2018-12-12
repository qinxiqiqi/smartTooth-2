//
//  SPPickerPetClass.h
//  JiangDiet
//
//  Created by 蓝现 on 2017/5/19.
//  Copyright © 2017年 yanghengzhan. All rights reserved.
//

#import "STPickerView.h"
NS_ASSUME_NONNULL_BEGIN

@class SPPickerPetClass;
@protocol  SPPickerPetDelegate<NSObject>
- (void)pickerDate:(SPPickerPetClass *)pickerDate channel:(NSString *)channel channelid:(NSString *)channelid;

@end


@interface SPPickerPetClass : STPickerView


@property(nonatomic, weak)id <SPPickerPetDelegate>delegate ;

@end
NS_ASSUME_NONNULL_END
