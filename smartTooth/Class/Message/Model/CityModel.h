//
//  CityModel.h
//  NaHao
//
//  Created by NIT on 2017/11/15.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *short_name;
@property (nonatomic, copy) NSString *zip_code;
@end
