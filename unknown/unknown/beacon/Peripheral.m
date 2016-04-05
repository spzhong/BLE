///
//  ViewController.m
//  Beacon
//
//  Created by spzhong on 15/7/10.
//   Copyright © 2016年 spzhong.. All rights reserved.
//

#import "Peripheral.h"


static Peripheral *peripheral = nil;

static id<PeripheralDelagete> pdelagete;

@implementation Peripheral




//创建一个单例对象
+(Peripheral *)share:(id<PeripheralDelagete>)delagete{
    if (peripheral == nil) {
        peripheral = [[Peripheral alloc] init];
    }
    pdelagete = delagete;
    return peripheral;
}



//注册生成基站
-(void)makePeripheralManager{

    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}



/**
 *  发送动态的特征数
 *
 *  @param data
 */
- (void)sendToSubscribers:(NSData *)data {
    
    
    [self.peripheralManager updateValue:data
                      forCharacteristic:self.CBcharacter
                   onSubscribedCentrals:nil];
    
    
    
    
//    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
//        NSLog(@"sendToSubscribers: peripheral not ready for sending state: %ld", self.peripheralManager.state);
//        return;
//    }
//    
//    BOOL success = [self.peripheralManager updateValue:data
//                                     forCharacteristic:self.CBcharacter
//                                  onSubscribedCentrals:nil];
//    
//    
//    //发送的结果
//    [pdelagete sendMsgResult:success];
}







/**
 *  关闭基站发射信号
 */
-(void)closePeripheralManager{
    [self.peripheralManager stopAdvertising];
    self.peripheralManager = nil;
}




#pragma CBPeripheralManagerDelegate - 必须实现的协议
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        NSLog(@"检查周边的状态");
        
        [self setupService];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        
    }
}

#pragma CBPeripheralManagerDelegate - 必须实现的协议
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error{
    
    NSLog(@"你好，ibeacon");
    
    
}



/**
 *  检查到周边的状态后，即可设置服务，和特征（都需一个128位置的UUID）
 *  服务：
 *  特征：
 */
-(void)setupService{
    //创建一个特征类型的CBUUID
    CBUUID *chatacteristic = [CBUUID UUIDWithString:kCharacteristicUUID];
    //创建一个特征
    //properties :属性（）
    //permissions:权限（）
    self.CBcharacter = [[CBMutableCharacteristic alloc] initWithType:chatacteristic properties:CBCharacteristicPropertyNotify|CBCharacteristicPropertyWrite  value:nil permissions:CBAttributePermissionsWriteable|CBAttributePermissionsReadable];

    
    //创建一个服务的CBUUID
    CBUUID *service = [CBUUID UUIDWithString:kServiceUUID];
    self.CBservice =  [[CBMutableService alloc] initWithType:service primary:YES];
    [self.CBservice setCharacteristics:@[self.CBcharacter]];
    
  
    //将服务添加到周边管理器中
    [self.peripheralManager addService:self.CBservice];
}




#pragma CBPeripheralManagerDelegate - 非必须实现的协议
- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict{
    NSLog(@"1");
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    NSLog(@"开启广播服务");
    if (error==nil) {
        //开启广播服务
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:@"songpeizhong", CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:kServiceUUID]]}];
    }
    
}


//中心设备订阅了周边设备
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"4 : 中心设备已经订阅了当前周边设备");
    
    //就直接循环发送当前用户的数据
    
    //头
    Byte ACkValue[1] = {0};
    ACkValue[0] = 0xe0;
    NSMutableData *data = [NSMutableData dataWithBytes:ACkValue length:1];
    Request *request = [[Request alloc] init];
    request.postData = data;
    [[RequestQueue shared] addQueue:request];
    
    
    //中心
    NSString *string = [[Tool getUser] exchangeJsonstring];
    NSData *postData = [string dataUsingEncoding:NSUTF8StringEncoding];
    long len = 0;
    if (postData.length % 20 == 0) {
        len = postData.length/20;
    }else{
        len = 1 + postData.length/20;
    }
    for (long i = 0; i < len; i++) {
        long a = 20;
        if (i*20 + 20 > postData.length) {
            a = postData.length-i*20;
        }
        NSData *newData = [postData subdataWithRange:NSMakeRange(i*20, a)];
        Request *request = [[Request alloc] init];
        request.postData = newData;
        [[RequestQueue shared] addQueue:request];
    }
    //中心
    //尾部
    Byte wACkValue[1] = {0};
    wACkValue[0] = 0xe1;
    NSMutableData *dataw = [NSMutableData dataWithBytes:wACkValue length:1];
    Request *requestw = [[Request alloc] init];
    requestw.postData = dataw;
    [[RequestQueue shared] addQueue:requestw];
    
    
    
    //启动
    Request *srequest = [[RequestQueue shared] star];
    if(srequest != nil){
        [self sendToSubscribers:srequest.postData];
    }
    
}

//中心设备取消了订阅周边管理
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"5 : 中心设备取消订阅了当前周边设备");
    [[RequestQueue shared] clearAll];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"6 : %@",request.value);
}

//接受中心设备写入的数据
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"7 ： %@",requests);
    
    if (requests.count > 0) {
        CBATTRequest *cba = requests[0];
        [pdelagete callBackMsg:cba.value];
        NSData *msg = cba.value;
        NSData *newData = [msg subdataWithRange:NSMakeRange(0, msg.length)];
        NSString *aString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        if ([aString isEqualToString:@"slf"]) {
            Request *request = [[RequestQueue shared] next];
            if(request != nil){
                [self sendToSubscribers:request.postData];
            }
        }
    }
}


//updateValue:data forCharacteristic:self.CBcharacter onSubscribedCentrals
//更新特征后进行的调用
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    NSLog(@"8");
    
    
}




@end


