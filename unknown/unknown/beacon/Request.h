//
//  Request.h
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Request : NSObject


@property(nonatomic)int type;// 0中中心数据，1是头，2是尾
@property(nonatomic,strong)NSData *postData;//上传的数据

//周边特征和管理器
@property(nonatomic,strong)CBCentral *central;
@property(nonatomic,strong)CBCharacteristic *pcharacteristic;
//周边特征和管理器

/**
 *  周边设备更新特征数据
 *
 *  @param peripheralManager
 *
 *  @return  nil 为空则表示成功
 */
-(NSString *)updateValue:(CBPeripheralManager*)peripheralManager;

/**
 *  中心设备写入数据
 *
 *  @param peripheral
 *
 *  @return nil 为空则表示成功
 */
-(NSString *)writeValue:(CBPeripheral *)peripheral;

@end
