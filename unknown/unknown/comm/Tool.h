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
#import "zlib.h"
#import "Encryption.h"
#import <CommonCrypto/CommonDigest.h>


@interface Tool : NSObject


//更新用户的信息
+(void)uadataUserInfo;
//获取用户的信息
+(id)getUser;
//获取wifi的名称
+ (NSString *)getWifiName;
//获取网络的状态
+(NSString *)getNetWorkStates;

//压缩
+(NSData *)compressData:(NSData *)uncompressedData;
//解压
+(NSData *)uncompressZippedData:(NSData *)uncompressedData;

+(NSString *)md5:(NSString *)str;
+(NSString*)md5HexDigest:(NSString*)input;

//读取接口数据
+(NSString *)interface:(NSString*)code;

//获取周边管理设备距离中心的距离
-(CGFloat)CalculateDistance:(NSNumber*)RSSI;

@end
