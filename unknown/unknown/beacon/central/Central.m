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
    
    self.peripheralArray = [[NSMutableArray alloc] init];
    
    //关闭
    [[Peripheral share:nil] closePeripheralManager];
    
    //进行扫描
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
}



/**
 *  发送动态的特征数
 *
 *  @param data
 */
- (void)sendToSubscribers:(NSData *)data {
    
    //[self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
    //点击按钮开始访问
    NSString *ss = @"https://alpha-api.app.net/stream/0/posts/stream/global";
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@"101" forKey:@"code"];
    [postDic setObject:[Tool interface:@"101"] forKey:@"msg"];
    User *user = [Tool getUser];
    [postDic setObject:user.userId forKey:@"userId"];
    [postDic setObject:ss forKey:@"data"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:nil];
    
    
    Request *startRequest = [[CenrequestQueue shared] cenInitData:jsonData withCharacteristic:self.characteristic];
    //启动所有的
    [[CenrequestQueue shared] startAll_once:peripheralData.peripheral withStart:startRequest];
     
}







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
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",peripheral,pow(10,ci)];
    NSLog(@"周边的名称%@ , 距离 %@",peripheral.name,length);
//
//
//    [self.centralManger stopScan];
//    if (self.peripheral != peripheral) {
//        self.peripheral = peripheral;
//        // Connects to the discovered peripheral--开始连接一个周边的对象
//        [self.centralManger connectPeripheral:peripheral options:nil];
//    }
//
    
    [self.centralManger stopScan];
    
    
    //判断停止扫描设备
    if (self.peripheralArray.count>10) {
        [self.centralManger stopScan];
        return;
    }
    self.pperipheral = peripheral;
    //开始连接
    [self.centralManger connectPeripheral:peripheral options:nil];
    
}
/**
 *  基于一个连接的代理回调
 *
 *  @param central
 *  @param peripheral 周边对象
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    //加入中心设备--是包含中心设备
    peripheralData = [[PeripheralData alloc] init];
    peripheralData.peripheral = peripheral;
    //添加到管理周边设备中
    [self.peripheralArray addObject:peripheralData];
    
    //设置周边的一个委托
    [peripheral setDelegate:self];
    [peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
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
        [self.peripheralArray removeObject:aPeripheral];
        NSLog(@"发现错误的服务信息 %@",error);
        return;
    }
    for (CBService *service in aPeripheral.services) {
        //发现服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            [aPeripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]]  forService:service];
            
        }
    }
    
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
   
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
        [self.peripheralArray removeObject:peripheral];
        NSLog(@"发现错误的特征信息 %@",error);
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                //开始通知一个特征更新
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
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
        [self.peripheralArray removeObject:peripheral];
        NSLog(@"错误的场景通知状态:%@",error);
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
        return;
    }
    //通知启动
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    }else{
         [self.peripheralArray removeObject:peripheral];
        //通知已经stopped
        [self.centralManger cancelPeripheralConnection:peripheral];
    }
}


/**
 *  更新特征后的数据回调
 *
 *  @param peripheral
 *  @param characteristic
 *  @param error
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.characteristic = characteristic;
    self.pperipheral = peripheral;
    //首先判读数据不为空
    if (characteristic.value != nil) {
        //周边设备的特征
        peripheralData.characteristic = characteristic;
        
        Byte *headByte = (Byte *)[characteristic.value bytes];
        switch (headByte[0]) {
            case 0xe0://开始
                peripheralData.allData = [[NSMutableData alloc] initWithCapacity:0];
                break;
            case 0xe1://结束
                [self centralEndReadValue];
                break;
            default://中间数据
                [peripheralData.allData appendData:characteristic.value];
                break;
        }
        //告知周边已收到数据
        Byte ACkValue[1] = {0};
        ACkValue[0] = 0xe2;//返回通知数据
        NSMutableData *data = [NSMutableData dataWithBytes:ACkValue length:1];
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}
 
/**
 *  写入周边管理后的回调
 *
 *  @param peripheral
 *  @param characteristic
 *  @param error
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}



/**
 *  结束执行的类型
 *
 *  @param peripheral 当前的周边管理
 */
-(void)centralEndReadValue{
    
    NSData *newData = [Tool uncompressZippedData:peripheralData.allData];
    NSString *aString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [aString Json];
     
    
    //匹配接口数据
    switch ([dataDic[@"code"] integerValue]) {
        case  100://周边用户信息
        {
            NSDictionary *postData = dataDic[@"data"];
            User *newUser = (User *)[CoreData creat_coredata:@"User" withWhere_id:[NSString stringWithFormat:@"userId='%@'",postData[@"userId"]]];
            [newUser initData_dic:postData];
            peripheralData.perUser = newUser;
            
            
            //开始进行握手操作--将中心的数据发送给周边用户
            NSString *string = [[Tool getUser] exchangeJsonstring];
            NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
            Request *startRequest = [[CenrequestQueue shared] cenInitData:jsonData withCharacteristic:self.characteristic];
            //启动所有的
            [[CenrequestQueue shared] startAll_once:peripheralData.peripheral withStart:startRequest];
            
        }
            break;
        case  101://--其它接口
        {
            
        }
            break;
        default:
            break;
    }
    
    [cdelagete callBackMsg:dataDic[@"msg"]];
}




@end
