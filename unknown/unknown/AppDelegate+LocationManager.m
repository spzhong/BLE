//
//  AppDelegate+LocationManager.m
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "AppDelegate+LocationManager.h"

@implementation AppDelegate (LocationManager)


//创建定位信息
-(void)initCLLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager setActivityType:CLActivityTypeFitness];//定位数据作为车辆导航使
    // 设置距离过滤器为50米，表示每移动50米更新一次位置
    self.locationManager.distanceFilter = 0.1;
    //设置朝向距离过滤，没1米更新一下位置
    self.locationManager.headingFilter = 0.1;
    // 将视图控制器自身设置为CLLocationManager的delegate
    // 因此该视图控制器需要实现CLLocationManagerDelegate协议
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
}


//定位权限是否打开了
-(BOOL)locationManagerAuthority{
    [CLLocationManager significantLocationChangeMonitoringAvailable];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        NSLog(@"请打开定位服务");
        
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
        return NO;
    }
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        NSLog(@"This device does not support monitoring beacon regions");
        return NO;
    }
    return YES;
}




#pragma CLLocationManager 更新定位信息
//更新位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    // 依次获取CLLocation中封装的经度、纬度、高度、速度、方向等信息
    NSString *jingdu = [NSString stringWithFormat:@"%g",
                        location.coordinate.latitude];
    NSString *weidu = [NSString stringWithFormat:@"%g",
                       location.coordinate.longitude];
    NSString *gaodu = [NSString stringWithFormat:@"%g",
                       location.altitude];
    NSString *sudu = [NSString stringWithFormat:@"%g",
                      location.speed];
    NSString *fangixang = [NSString stringWithFormat:@"%g",
                           location.course];
    NSString *jicelou; // = [NSString stringWithFormat:@"%ld",location.floor.level];
    
    NSString *allMsg = [NSString stringWithFormat:@"经度：%@,纬度：%@,高度：%@,速度：%@,方向：%@,所在楼层:%@",jingdu,weidu,gaodu,sudu,fangixang,jicelou];
    
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:allMsg,@"allMsg",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"didUpdateLocations" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //NSLog(@"经度：%@,纬度：%@,高度：%@,速度：%@,方向：%@,所在楼层:%@",jingdu,weidu,gaodu,sudu,fangixang,jicelou);
}

// 定位失败时激发的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    //NSLog(@"定位失败: %@",error);
}

//更新朝向
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    //NSLog(@"朝向 %@",newHeading.description);
}
#pragma CLLocationManager 更新定位信息


@end
