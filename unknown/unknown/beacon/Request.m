//
//  Request.m
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import "Request.h"

@implementation Request

/**
 *  更新特征数据
 *
 *  @param peripheralManager
 *
 *  @return  nil 为空则表示成功
 */
-(NSString *)updateValue:(CBPeripheralManager*)peripheralManager{
    
    if (peripheralManager==nil) {
        return @"100周边管理器已经释放!";
    }
    
    NSArray *cenArray = [NSArray arrayWithObjects:self.central, nil];
    //更新数据
    BOOL isOk = [peripheralManager updateValue:self.postData
                             forCharacteristic:(CBMutableCharacteristic *)self.pcharacteristic
                          onSubscribedCentrals:cenArray];
    if (isOk) {
        return nil;
    }
    return @"105更新周边设备信息错误！";
}


/**
 *  中心设备写入数据
 *
 *  @param peripheral
 *
 *  @return nil 为空则表示成功
 */
-(NSString *)writeValue:(CBPeripheral *)peripheral{
    
    if (peripheral==nil) {
        return @"108周边管理器已经释放!";
    }
    
    //向周边设备写入数据
    [peripheral writeValue:self.postData forCharacteristic:self.pcharacteristic type:CBCharacteristicWriteWithResponse];
    
    return nil;
}


@end
