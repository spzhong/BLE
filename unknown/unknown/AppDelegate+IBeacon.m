//
//  AppDelegate+IBeacon.m
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "AppDelegate+IBeacon.h"

@implementation AppDelegate (IBeacon)


//注册
-(void)scansearchBeaconwithApp:(NSString *)uuid withIdentifier:(NSString *)identifier{
    
    AppDelegate *App = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //基站信息
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid]
                                    identifier:identifier];
    //支持后台运行
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    
    //开始检测基站
    [App.locationManager startMonitoringForRegion:beaconRegion];
}



#pragma CLLocationManagerDelegate
//已经开始
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    //基站信息
    NSLog(@"开始检测基站 ，identifier:%@",region.identifier);
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}
//检测区域失败
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    //基站信息
    NSLog(@"检测基站失败 ，identifier:%@",region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    NSLog(@"visit");
}

#pragma CLLocationManagerDelegate



//进入了基站的范围
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    NSLog(@"进入了基站的范围，identifier:%@",region.identifier);
 
    
}

//退出基站的范围
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    NSLog(@"离开了基站的范围，identifier:%@",region.identifier);
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:(CLBeaconRegion *)region,@"region",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"didExitRegion" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

//beacons 被检测的回调的委托协议
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region{
    
    //判断进入基站的
    if ([beacons count]==0) {
        NSLog(@"暂无任何的基站数据");
        return;
    }
    
    NSLog(@"检测基站 ，identifier:%@",region.identifier);
    
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:beacons,@"beacons",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"didRangeBeacons" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
    // Beacon found!
    int ii = 0;
    for (CLBeacon *foundBeacon in beacons) {
        // You can retrieve the beacon data from its properties
        NSString *uuid = foundBeacon.proximityUUID.UUIDString;
         
        NSString *major = [NSString stringWithFormat:@"%ld", (long)foundBeacon.major.integerValue];
        NSString *minor = [NSString stringWithFormat:@"%ld", (long)foundBeacon.minor.integerValue];
        NSString *rssi = [NSString stringWithFormat:@"%ld", (long)foundBeacon.rssi];
        NSString *accuracy = [NSString stringWithFormat:@"%.4f",foundBeacon.accuracy];
        long proximity = (long)foundBeacon.proximity;
        
        NSLog(@"%d     基站的信息 uuid:%@|major:%@|minor:%@|rssi:%@|proximity:%ld|accuracy距离:%@米",ii,uuid,major,minor,rssi,proximity,accuracy);
        ii++;
    }
    
}





@end
