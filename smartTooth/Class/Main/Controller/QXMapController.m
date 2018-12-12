//
//  QXMapController.m
//  SmartTooth
//
//  Created by qinxi on 2018/11/2.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXMapController.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotationView.h>
#import <MapKit/MKAnnotation.h>
#import "QXAnnotation.h"
#import "QXClinicModel.h"

@interface QXMapController ()<MKMapViewDelegate>
    @property (nonatomic, weak) MKMapView *mapView;
    @property (nonatomic, strong) CLLocationManager *manager;
    @end

@implementation QXMapController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView = mapView;
    [self.view addSubview:mapView];
    //设置代理(用户的位置)
    self.mapView.delegate = self;
    
    //设置地图视图旋转
    self.mapView.rotateEnabled = NO;
    //设置地图的类型
    self.mapView.mapType = MKMapTypeStandard;
    
    CLLocationCoordinate2D curLocation;
    curLocation.latitude = [self.clinic.latitude doubleValue];
    curLocation.longitude = [self.clinic.longitude doubleValue];
    
    //设置地图跨度
    MKCoordinateSpan span;
    span.latitudeDelta = 0.008;
    span.longitudeDelta = 0.008;
    
    //显示地图
    MKCoordinateRegion region = {curLocation, span};
    [self.mapView setRegion:region];
    
    [self addAnotation];
    
}
    
- (void)addAnotation {
    QXAnnotation *annotation = [QXAnnotation new];
    //设置三个属性(39.123+1~9)
    double latitude = [self.clinic.latitude doubleValue];
    double longitude = [self.clinic.longitude doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = self.clinic.cname;
    annotation.subtitle = self.clinic.address;
    //V2:
    annotation.image = [UIImage imageNamed:@"icon.png"];
    //添加到地图视图上
    [self.mapView addAnnotation:annotation];
}
    
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"viewForAnnotation");
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
    }
    annotationView.image = [UIImage imageNamed:@"annotation"]; //更换大头针的图片
    annotationView.canShowCallout = YES;
    return annotationView;
}
    
@end
