//
//  Tool.m
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "Tool.h"


@implementation Tool


//更新用户的信息
+(void)uadataUserInfo{
    //判断用户
    User *user = [Tool getUser];
    if (user==nil) {
        NSString *stringId = [[NSUUID UUID] UUIDString];
        user = (User *)[CoreData creat_coredata:@"User" withWhere_id:[NSString stringWithFormat:@"userId='%@'",stringId]];
        user.name = [UIDevice currentDevice].name;
        user.userId = stringId;
        [[NSUserDefaults standardUserDefaults] setObject:stringId forKey:@"curLoginUserId"];
    }
    user.netType = [Tool getNetWorkStates];
    user.wifi = [Tool getWifiName];
    [CoreData save_coredata];
}



//获取用户的信息
+(id)getUser{
    NSString *userIDLoc = [[NSUserDefaults standardUserDefaults] valueForKey:@"curLoginUserId"];
    if (userIDLoc == nil) {
        return nil;
    }
    NSString *where = [NSString stringWithFormat:@"userId='%@'",userIDLoc];
    User *user = (User *)[CoreData selcet_OneData:@"User" withWhere_id:where];
    return user;
}


//获取wifi的名称
+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    NSDictionary *networkInfo = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    
    return [networkInfo description];
}

//获取网络的状态
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


@end
