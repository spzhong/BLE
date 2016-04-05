//
//  Tool.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface Tool : NSObject


//更新用户的信息
+(void)uadataUserInfo;
//获取用户的信息
+(id)getUser;
//获取wifi的名称
+ (NSString *)getWifiName;
//获取网络的状态
+(NSString *)getNetWorkStates;

@end
