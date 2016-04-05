//
//  RequestQueue.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface Request : NSObject

@property(nonatomic)int status;//0是待执行，1是执行中，3是执行结束
@property(nonatomic,strong)CBCentral *central;
@property(nonatomic,strong)CBCharacteristic *characteristic;
@property(nonatomic,strong)NSData *postData;//上传的数据

@end



@interface RequestQueue : NSObject
 

/**
 *  创建一个队列单例
 *
 *  @return self
 */
+(id)shared;

/**
 *  启动
 */
-(Request *)star;
/**
 *  启动下一个
 */
-(Request *)next;
/**
 *  清空队列
 */
-(void)clearAll;

/**
 *  添加到队列中
 *
 *  @param request
 */
-(void)addQueue:(Request *)request;

@end
