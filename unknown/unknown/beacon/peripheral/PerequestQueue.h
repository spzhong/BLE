//
//  RequestQueue.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Request.h"




@interface PerequestQueue : NSObject
{
    NSMutableArray *queueArray;//队列数组
}

/**
 *  创建一个队列单例
 *
 *  @return self
 */
+(id)shared;

/**
 *  启动队列
 *
 *  @param peripheralManger
 *
 *  @return nil 表示成功， 错误的信息
 */
-(NSString *)star:(CBPeripheralManager *)peripheralManger;
/**
 *  启动队列中下一个
 *
 *  @param peripheralManger
 *
 *  @return nil 表示成功， 错误的信息
 */
-(NSString *)next:(CBPeripheralManager *)peripheralManger;
/**
 *  清空队列
 */
-(void)clearAll;
/**
 *  清空指定类型信息的数据
 */
-(void)clearAllRequestWithCenterl:(Request *)request;
/**
 *  添加到队列中
 *
 *  @param request
 */
-(void)addQueue:(Request *)request;

/**
 *  初始化数据
 *
 *  @param postData
 *  @param characteristic
 *  @param central
 */
-(void)initData:(NSData *)postData withCharacteristic:(CBCharacteristic*)characteristic withCentral:(CBCentral *)central;



@end
