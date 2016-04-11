//
//  CenrequestQueue.h
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface CenrequestQueue : NSObject
{
    NSMutableArray *cenqueueArray;//队列数组
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
 *  @param characteristic
 *
 *  @return nil 表示成功， 错误的信息
 */
-(NSString *)starc:(CBPeripheral *)peripheral;
/**
 *  启动队列中下一个
 *
 *  @param peripheralManger
 *
 *  @return nil 表示成功， 错误的信息
 */
-(NSString *)nextc:(CBPeripheral *)peripheral;
/**
 *  启动当前组所有的数据请求
 *
 *  @param peripheral
 *  @param strarRequest
 */
-(void)startAll_once:(CBPeripheral *)peripheral withStart:(Request *)strarRequest;
/**
 *  清空队列
 */
-(void)clearAll;
/**
 *  清空指定类型信息的数据
 */
-(void)clearAllRequestWithPeripheral:(Request *)request;
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
-(Request *)cenInitData:(NSData *)postData withCharacteristic:(CBCharacteristic*)characteristic;


@end
