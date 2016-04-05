//
//  AppDelegate+LocationManager.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (LocationManager)

//定位权限是否打开了
-(BOOL)locationManagerAuthority;
//创建定位信息
-(void)initCLLocationManager;

@end
