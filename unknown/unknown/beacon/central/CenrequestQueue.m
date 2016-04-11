//
//  CenrequestQueue.m
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import "CenrequestQueue.h"

@implementation CenrequestQueue


static CenrequestQueue *cenqueue = nil;

static long cenoffSet;

/**
 *  创建一个队列单例
 *
 *  @return self
 */
+(id)shared{
    if (cenqueue==nil) {
        cenqueue = [[CenrequestQueue alloc] init];
        cenoffSet = -1;
    }
    return cenqueue;
}

/**
 *  清空队列
 */
-(void)clearAll{
    [cenqueueArray removeAllObjects];
    cenoffSet = -1;
}

/**
 *  清空指定信息的数据
 */
-(void)clearAllRequestWithPeripheral:(Request *)request{
    
    NSMutableIndexSet *indexsets = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i < cenqueueArray.count; i++) {
        Request *need = [cenqueueArray objectAtIndex:i];
        if (need.pcharacteristic == request.pcharacteristic) {
            [indexsets addIndex:i];
        }
    }
    [cenqueueArray removeObjectsAtIndexes:indexsets];
    cenoffSet = -1;
}

/**
 *  添加到队列中
 *
 *  @param request
 */
-(void)addQueue:(Request *)request{
    [cenqueueArray addObject:request];
}

/**
 *  初始化数据
 *
 *  @param postData
 *  @param characteristic
 *  @param central
 *
 *  @return head Request
 */
-(Request *)cenInitData:(NSData *)postData withCharacteristic:(CBCharacteristic*)characteristic{
    
    if (cenqueueArray==nil) {
        cenqueueArray = [[NSMutableArray alloc] init];
    }
    
    //头
    Request *head = [self makeHead];
    head.pcharacteristic = characteristic;
    
    //中心数据
    [self makeMidData:[Tool compressData:postData] withCharacteristic:characteristic];
    
    //尾
    Request *foot = [self makeFooter];
    foot.pcharacteristic = characteristic;
    
    return head;
}


/**
 *  启动
 *
 *  @param peripheralManger 周边管理
 */
-(NSString *)starc:(CBPeripheral *)peripheral{
    cenoffSet = -1;
    if (cenqueueArray.count > 0) {
        return [self nextc:peripheral];
    }
    return @"107队列数组为空异常";
}

/**
 *  下一个
 *
 *  @param peripheralManger 周边管理
 */
-(NSString *)nextc:(CBPeripheral *)peripheral{
    cenoffSet=cenoffSet+1;
    if (cenoffSet >= cenqueueArray.count) {
        [self clearAll];
        return @"106清空队列信息";
    }
    //取出第offSet个Request
    Request *request = cenqueueArray[cenoffSet];
    NSString *result = [request writeValue:peripheral];
    //一旦发现数据分流异常，就讲此类型的数据全部清空
    if (result != nil) {
        [self clearAllRequestWithPeripheral:request];
        return result;
    }
    //发送成功的执行--判断是否是尾步
    if (request.type==2) {
        //则需要清空该段数据的信息
        [self clearAllRequestWithPeripheral:request];
    }
    return nil;
}


/**
 *  启动所有的
 *
 *  @param peripheral
 */
-(void)startAll_once:(CBPeripheral *)peripheral withStart:(Request *)strarRequest{
    
    NSMutableArray *allRequest = [[NSMutableArray alloc] init];
    for (Request *request in cenqueueArray) {
        if (request.pcharacteristic == strarRequest.pcharacteristic) {
            [allRequest addObject:request];
        }
    }
    //启动所有的
    for (Request *newRequest in allRequest) {
        NSString *result = [newRequest writeValue:peripheral];
        //一旦发现数据分流异常，就讲此类型的数据全部清空
        if (result != nil) {
            break;
        }
        //发送成功的执行--判断是否是尾步
        if (newRequest.type==2) {
            //则需要清空该段数据的信息
            [self clearAllRequestWithPeripheral:newRequest];
        }
    }
    cenoffSet = -1;
}



/**
 *  创建头部
 */
-(Request *)makeHead{
    //头
    Byte ACkValue[1] = {0};
    ACkValue[0] = 0xe0;
    NSMutableData *data = [NSMutableData dataWithBytes:ACkValue length:1];
    Request *request = [[Request alloc] init];
    request.postData = data;
    request.type = 1;//头
    [[CenrequestQueue shared] addQueue:request];
    return request;
}

/**
 *  组合尾部
 */
-(Request *)makeFooter{
    //尾部
    Byte wACkValue[1] = {0};
    wACkValue[0] = 0xe1;
    NSMutableData *dataw = [NSMutableData dataWithBytes:wACkValue length:1];
    Request *requestw = [[Request alloc] init];
    requestw.postData = dataw;
    requestw.type = 2;//尾
    [[CenrequestQueue shared] addQueue:requestw];
    return requestw;
}

/**
 *  组合中间的数据
 *
 *  @param postData 上传的数据
 *  @param characteristic 周边信息
 *  @param central 目标中心设备
 */
-(void)makeMidData:(NSData *)postData withCharacteristic:(CBCharacteristic*)characteristic{
    //中心
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
        request.pcharacteristic = characteristic;
        [[CenrequestQueue shared] addQueue:request];
    }
    //中心
}



@end
