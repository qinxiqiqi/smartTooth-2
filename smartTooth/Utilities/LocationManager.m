//
//  LocationManager.m
//  BoaJiaoyu
//
//  Created by jsmysoft on 15/12/22.
//  Copyright © 2015年 jsmysoft. All rights reserved.
//

#import "LocationManager.h"
#import "ToothManager.h"

static LocationManager *manager = nil;

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D locationCoordinate2D; // 当前位置经纬度
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder        *geocoder;//逆地理编码

@end

@implementation LocationManager

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
    
}

-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}


+ (LocationManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            manager = [[LocationManager alloc] init];
        }
        
    });
    
    return manager;
}

//定位
- (void)beginLocation
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //需要在plist中加 NSLocationAlwaysUsageDescription 才会有提示框
    [_locationManager requestAlwaysAuthorization];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        
        UIAlertController *alertController = [UIAlertController alertViewTitle:@"位置服务" message:@"为了更好的体验哪好，是否立即打开定位" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" handler:^(UIAlertAction * _Nullable action) {
            if ([action.title isEqualToString:@"确定"]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    
    //设置代理
    _locationManager.delegate=self;
    //设置定位精度(最精确定位)
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;
    //十米定位一次
    _locationManager.distanceFilter=distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
}

#pragma mark 位置编码
//地理编码,根据地名得到坐标
- (void)getCoordinateByAddress:(NSString *)address
{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        
        NSLog(@"%f",location.coordinate.longitude);//经度
        NSLog(@"%f",location.coordinate.latitude);// 纬度
        CLRegion *region=placemark.region;//区域
       
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

//反地理编码,根据坐标取的地名
- (void)getAddressByLatitude:(CLLocationCoordinate2D)coordinate success:(void (^)(NSString *,NSString *))success
{
    //通过经纬度得到位置
    CLLocation *location=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        //这里只定位到沙河镇
        NSLog(@"%@,%@,%@,%@,%@",placemark.addressDictionary[@"City"],placemark.addressDictionary[@"FormattedAddressLines"][0],placemark.addressDictionary[@"Name"],placemark.addressDictionary[@"State"],placemark.addressDictionary[@"SubLocality"]);
        NSString *detail = [NSString stringWithFormat:@"%@%@%@%@",placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"Name"],placemark.addressDictionary[@"State"]];
        success(placemark.addressDictionary[@"City"],detail);
    }];
}


#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"经度:%f 纬度:%f", coordinate.longitude,coordinate.latitude);
    
    //进行位置编码
    __block LocationManager *weakSelf = self;
    if (self.addressGetBlock) {
        self.addressGetBlock(coordinate.longitude, coordinate.latitude);
    }
    [self getAddressByLatitude:coordinate success:^(NSString *cityName, NSString *detail) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"address"] = detail;
        param[@"longitude"] = [NSString stringWithFormat:@"%f",coordinate.longitude];
        param[@"latitude"] = [NSString stringWithFormat:@"%f",coordinate.latitude];
        [[ToothManager shareManager] updateUserInfo:param];
        weakSelf.locationGet(cityName,detail);
    }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}

@end
