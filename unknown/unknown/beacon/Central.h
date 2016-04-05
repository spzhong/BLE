//
//  Central.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "Global.h"

@protocol CentralDelagete <NSObject>

@required
-(void)sendMsgResult:(BOOL)isok;
-(void)callBackMsg:(NSData *)msg;
@optional

@end


@interface Central : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    NSMutableData *allData;
}
@property(nonatomic,strong) CBCharacteristic *characteristic;//特征
@property(nonatomic,strong) CBCentralManager *centralManger;
@property(nonatomic,strong) NSMutableData *data;
@property(nonatomic,strong) CBPeripheral *peripheral;//一个周边对象
@property(nonatomic,strong) CBCentral *central;//中心对象


+(Central *)share:(id<CentralDelagete>)delagete;
/**
 *  创建中心管理
 */
-(void)makeCentralManager;


/**
 *  发送动态的特征数
 *
 *  @param data
 */
- (void)sendToSubscribers:(NSData *)data;


/**
 *  关闭中心扫描
 */
-(void)closeCentalManager;


@end
