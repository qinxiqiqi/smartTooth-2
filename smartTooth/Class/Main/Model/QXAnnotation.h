//
//  QXAnnotation.h
//  SmartTooth
//
//  Created by qinxi on 2018/11/3.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QXAnnotation : NSObject<MKAnnotation>
//大头针的地理位置
@property (nonatomic) CLLocationCoordinate2D coordinate;
//标识大头针的两个title标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//自定义的图片属性
@property (nonatomic, strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END
