//
//  beacon.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Beacon : NSObject<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;


+(Beacon *)share;

/**
 *  创建一个基站灯塔
 *
 *  @param uuid
 *  @param identifier
 *  @param major
 *  @param minor
 */
-(void)beaconRegisteredwithApp:(NSString *)uuid withIdentifier:(NSString *)identifier withmajor:(CLBeaconMajorValue)major withminor:(CLBeaconMinorValue)minor;

///**
// *  关闭基站发射信号
// */
//-(void)closeBeacon;

@end
