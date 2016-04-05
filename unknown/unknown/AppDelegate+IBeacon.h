//
//  AppDelegate+IBeacon.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (IBeacon)

//扫描 基站
-(void)scansearchBeaconwithApp:(NSString *)uuid withIdentifier:(NSString *)identifier;

@end
