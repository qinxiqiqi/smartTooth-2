//
//  LocationManager.h
//  BoaJiaoyu
//
//  Created by jsmysoft on 15/12/22.
//  Copyright © 2015年 jsmysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationGetBlock)(NSString *,NSString *);

@interface LocationManager : NSObject

@property (nonatomic,strong)LocationGetBlock locationGet;//获取城市
@property (nonatomic,strong)void(^addressGetBlock)(float longi,float latti);//获取经纬度

+ (LocationManager *)shareManager;

- (void)beginLocation;

- (void)getCoordinateByAddress:(NSString *)address;

- (void)getAddressByLatitude:(CLLocationCoordinate2D)coordinate success:(void (^)(NSString *,NSString *))success;

@end
