//
//  Tool.m
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "Tool.h"
#import "User.h"



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
    user.device = @"IOS";
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
                    state = @"NO";
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


//压缩
+(NSData *)compressData:(NSData *)uncompressedData
{ 
    if ([uncompressedData length] == 0) return uncompressedData;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[uncompressedData bytes];
    strm.avail_in = (unsigned int)[uncompressedData length];
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    
    
    return [[NSData dataWithData:compressed] AES256EncryptWithKey:[Tool md5:@"token"] withInitialization:NULL];
}

//解压
+(NSData *)uncompressZippedData:(NSData *)compressedData
{
    
    compressedData = [compressedData AES256DecryptWithKey:[Tool md5:@"token"] withInitialization:NULL];
    
    if ([compressedData length] == 0) return compressedData;
    
    NSUInteger full_length = [compressedData length];
    
    NSUInteger half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }    
}

+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)md5HexDigest:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


//去读接口配置文件
+(NSString *)interface:(NSString*)code{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Interface" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSString *msg = @"";
    for (NSDictionary *dic in dataArray) {
        if ([dic[@"code"] isEqualToString:code]) {
            msg = dic[@"msg"];
            break;
        }
    }
    return msg;
}

//获取周边管理设备距离中心的距离
-(CGFloat)CalculateDistance:(NSNumber*)RSSI{
    int rssi = abs([RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    return pow(10,ci);
}


@end
