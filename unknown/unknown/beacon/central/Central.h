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
#import "CenrequestQueue.h"
#import "PeripheralData.h"




@protocol CentralDelagete <NSObject>

@required
-(void)sendMsgResult:(BOOL)isok;
-(void)callBackMsg:(NSString *)msg;
@optional

@end


@interface Central : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    NSMutableData *allData;
    PeripheralData *peripheralData;//周边设备储存信息
}
@property(nonatomic,strong) CBCharacteristic *characteristic;//特征
@property(nonatomic,strong) CBCentralManager *centralManger;
@property(nonatomic,strong) NSMutableData *data;

@property(nonatomic,strong) NSMutableArray *peripheralArray;//一个周边对象数组

@property(nonatomic,strong) CBPeripheral *pperipheral;//一个周边对象数
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
