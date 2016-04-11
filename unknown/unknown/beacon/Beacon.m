//
//  beacon.m
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "Beacon.h"



static Beacon *beacon = nil;

@implementation Beacon


//创建一个单例对象
+(Beacon *)share{
    if (beacon == nil) {
        beacon = [[Beacon alloc] init];
    }
    return beacon;
}



//注册生成基站
-(void)beaconRegisteredwithApp:(NSString *)uuid withIdentifier:(NSString *)identifier withmajor:(CLBeaconMajorValue)major withminor:(CLBeaconMinorValue)minor{
    //创建灯塔发射信号
    NSUUID *uuids = [[NSUUID alloc] initWithUUIDString:uuid];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuids
                                                                  major:major
                                                                  minor:minor
                                                             identifier:identifier];
    //支持后台运行
    self.myBeaconRegion.notifyEntryStateOnDisplay = YES;
    self.myBeaconRegion.notifyOnEntry = YES;
    self.myBeaconRegion.notifyOnExit = YES;
    //开始发送广播
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
     
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}
/**
 *  关闭基站发射信号
 */
-(void)closeBeacon{
    [self.peripheralManager stopAdvertising];
}





#pragma CBPeripheralManagerDelegate - 必须实现的协议
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        NSLog(@"发送基站信息");
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        
    }
}

#pragma CBPeripheralManagerDelegate - 必须实现的协议
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error{
    NSLog(@"你好，ibeacon");
}




@end
