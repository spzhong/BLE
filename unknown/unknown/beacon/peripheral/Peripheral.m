///
//  ViewController.m
//  Beacon
//
//  Created by spzhong on 15/7/10.
//   Copyright © 2016年 spzhong.. All rights reserved.
//

#import "Peripheral.h"
#import "CentralData.h"



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

    //首先判断当前用户的网路状态
    User *curUser = [Tool getUser];
    
    if ([curUser.netType isEqualToString:@"WIFI"]) {
        
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
    }else if ([curUser.netType isEqualToString:@"NO"]) {
        //do onthing
    
    }else{
        
        //2G，3G，4G -- 是否愿意出售流量
        if ([curUser.isallow_xg isEqualToString:@"yes"]) {
            
            self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            
        }
        
    }
    
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
    
    //设置快速的长连接
    [self.peripheralManager setDesiredConnectionLatency:CBPeripheralManagerConnectionLatencyHigh forCentral:central];
     
    centralData = [[CentralData alloc] init];
    
    
    //就直接循环发送当前用户的数据
    NSString *string = [[Tool getUser] exchangeJsonstring];
    NSData *postData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //启动队列
    PerequestQueue *queue = [PerequestQueue shared];
    [queue initData:postData withCharacteristic:characteristic withCentral:central];
    [queue star:self.peripheralManager];
    
    
}

//中心设备取消了订阅周边管理
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"5 : 中心设备取消订阅了当前周边设备");
    [[PerequestQueue shared] clearAll];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"6 : %@",request.value);
}

//接受中心设备写入的数据
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"7 ： %@",requests);
    
    if (requests.count > 0) {
        
        for (CBATTRequest *cba in requests) {
            Byte *headByte = (Byte *)[cba.value bytes];
            switch (headByte[0]) {
                case 0xe0://开始
                    centralData.allData = [[NSMutableData alloc] initWithCapacity:0];
                    break;
                case 0xe1://结束
                    [self peripheralEndReadValue:cba.central withcharacteristic:cba.characteristic];
                    break;
                case 0xe2://告知已经收到信息了-并且执行下一数据操作
                    [[PerequestQueue shared] next:self.peripheralManager];
                    break;
                default://中间数据
                    [centralData.allData appendData:cba.value];
                    break;
            }
        }
        
    }
}


//updateValue:data forCharacteristic:self.CBcharacter onSubscribedCentrals
//更新特征后进行的调用
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    NSLog(@"8");
    
    
}




/**
 *  结束执行的类型
 *
 *  @param peripheral 当前的周边管理
 */
-(void)peripheralEndReadValue:(CBCentral *)central withcharacteristic:(CBCharacteristic*)characteristic{
    
    NSData *newData = [Tool uncompressZippedData:centralData.allData];
    NSString *aString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [aString Json];
    
    NSString *userId = dataDic[@"userId"];
    NSLog(@"来源的用户ID  %@",userId);
    
    
    //匹配接口数据
    switch ([dataDic[@"code"] integerValue]) {
        case  100://中心用户信息
        {
            NSDictionary *postData = dataDic[@"data"];
            User *newUser = (User *)[CoreData creat_coredata:@"User" withWhere_id:[NSString stringWithFormat:@"userId='%@'",postData[@"userId"]]];
            [newUser initData_dic:postData];
            //peripheralCentral.cenUser = newUser;
        }
            break;
        case  101://--其它接口--访问百度的接口
        {
            NSString *str = dataDic[@"data"];
            NSLog(@"接受的数据 %@",str);
             
            //NSString *str=[NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSLog(@"周边返回的数据 %@",html);
                
                //NSData* postData=[html dataUsingEncoding:NSUTF8StringEncoding];
                
                NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                [postDic setObject:@"101" forKey:@"code"];
                [postDic setObject:[Tool interface:@"101"] forKey:@"msg"];
                [postDic setObject:[html Json] forKey:@"data"];
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:nil];
                
                //开始发送
                PerequestQueue *queue = [PerequestQueue shared];
                [queue initData:jsonData withCharacteristic:characteristic withCentral:central];
                [queue next:self.peripheralManager];
              
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"发生错误！%@",error);
            }];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];
            
        }
            break;
        default:
            break;
    }
    
    [pdelagete callBackMsg:dataDic[@"msg"]];
}



@end


