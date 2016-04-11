//
//  Beacon.h
//  BeaconReceiver
//
//  Created by spzhong on 15/7/18.
//   Copyright © 2016年 spzhong.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "Global.h"
#import "PerequestQueue.h"

//#import "CentralData.h"


@class CentralData;

 


@protocol PeripheralDelagete <NSObject>

@required
-(void)sendMsgResult:(BOOL)isok;
-(void)callBackMsg:(NSString *)msg;
@optional

@end



@interface Peripheral : NSObject<CBPeripheralManagerDelegate>
{
    NSMutableArray *queueArray;
    CentralData *centralData;
}

@property (retain,nonatomic)CBMutableService *CBservice;
@property (retain,nonatomic)CBMutableCharacteristic *CBcharacter;
@property (retain, nonatomic) CBPeripheralManager *peripheralManager;


+(Peripheral *)share:(id<PeripheralDelagete>)pdelagete;

/**
 *  创建周边管理
 */
-(void)makePeripheralManager;



/**
 *  关闭基站发射信号
 */
-(void)closePeripheralManager;

/**
 *  发送动态的特征数
 *
 *  @param data
 */
- (void)sendToSubscribers:(NSData *)data;

@end
