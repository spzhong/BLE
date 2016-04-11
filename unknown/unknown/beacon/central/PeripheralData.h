//
//  PeripheralData.h
//  unknown
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  中心设备接收周边设备的数据model
 */
@interface PeripheralData : NSObject

@property(nonatomic,strong)CBPeripheral *peripheral;//周边
@property(nonatomic,strong)User *perUser;//周边用户设备信息
@property(nonatomic,strong)CBCharacteristic *characteristic;//周边设备的特征
@property(nonatomic,strong)NSMutableData *allData;//发送的数据



@end
