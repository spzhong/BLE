//
//  Central.m
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "Central.h"

static Central *central = nil;

static id<CentralDelagete> cdelagete;

@implementation Central


+(Central *)share:(id<CentralDelagete>)delagete{
    if (central==nil) {
        central = [[Central alloc] init];
    }
    cdelagete = delagete;
    return central;
}


-(void)makeCentralManager{
    
    //关闭
    [[Peripheral share:nil] closePeripheralManager];
    
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    
}



/**
 *  发送动态的特征数
 *
 *  @param data
 */
- (void)sendToSubscribers:(NSData *)data {
     
    
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}


//





//关闭中心扫描
-(void)closeCentalManager{
    [self.centralManger stopScan];
    self.centralManger = nil;
}


#pragma CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
           CBUUID *service = [CBUUID UUIDWithString:kServiceUUID];
            //开始扫描周边的服务
            //service 为nil，则是查找附近的所有的服务
            [self.centralManger scanForPeripheralsWithServices:@[service] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
        }
            break;
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}
/**
 *  一旦一个周边在寻找的说被发现了，中央代理就会执行回调
 *
 *  @param central
 *  @param peripheral        一个周边的对象
 *  @param advertisementData 广播的数据
 *  @param RSSI              信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    int rssi = abs([RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"周边的名称%@ , 距离 %@",peripheral.name,length);
    

    [self.centralManger stopScan];
    if (self.peripheral != peripheral) {
        self.peripheral = peripheral;
        // Connects to the discovered peripheral--开始连接一个周边的对象
        [self.centralManger connectPeripheral:peripheral options:nil];
    }
}
/**
 *  基于一个连接的代理回调
 *
 *  @param central
 *  @param peripheral 周边对象
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.data setLength:0];
    //设置周边的一个委托
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
}
/**
 *  基于一个连接的代理回调失败
 *
 *  @param central
 *  @param peripheral 周边对象
 *  @param error      错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{

}
/**
 *  搜到周边的服务的回调信息
 *
 *  @param aPeripheral
 *  @param error
 */
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"发现错误的服务信息 %@",error);
        return;
    }
    for (CBService *service in aPeripheral.services) {
        //发现服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            [self.peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]]  forService:service];
        }
    }
    
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
//    int rssi = abs([peripheral.RSSI intValue]);
//    CGFloat ci = (rssi - 49) / (10 * 4.);
//    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
//    NSLog(@"距离 %@",length);
}

//计算的value
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error{

}


/**
 *  发现一个特征后，周边代理会接收-peripheral:didDiscoverCharacteristicsForService:error:。现在，一旦特征的值被更新，用-setNotifyValue:forCharacteristic:，周边被请求通知它的代理。
 *  @param peripheral
 *  @param service
 *  @param error
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"发现错误的特征信息 %@",error);
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                //开始通知一个特征更新
                [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
}
/**
 *   如果一个特征被更新，然后周边的代理就可以接收了
 *
 *  @param peripheral
 *  @param characteristic 特征
 *  @param error
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"错误的场景通知状态:%@",error);
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
        return;
    }
    
    self.characteristic = characteristic;
    //通知启动
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    }else{
        //通知已经stopped
        [self.centralManger cancelPeripheralConnection:peripheral];
    }
}




- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (characteristic.value != nil) {
        
        Byte *headByte = (Byte *)[characteristic.value bytes];
        switch (headByte[0]) {
            case 0xe0:
                allData = [[NSMutableData alloc] initWithCapacity:0];
                break;
            case 0xe1:
                [cdelagete callBackMsg:allData];
                break;
            default:
                [allData appendData:characteristic.value];
                break;
        }
        
        [self.peripheral writeValue:[@"slf" dataUsingEncoding:NSUTF8StringEncoding]forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}
 

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}





@end
