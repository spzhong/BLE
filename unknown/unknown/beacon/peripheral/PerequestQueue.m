//
//  RequestQueue.m
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "PerequestQueue.h"
 

@implementation PerequestQueue


static PerequestQueue *queue = nil;
static long offSet;

/**
 *  创建一个队列单例
 *
 *  @return self
 */
+(id)shared{
    if (queue==nil) {
        queue = [[PerequestQueue alloc] init];
        offSet = -1;
    }
    return queue;
}

/**
 *  清空队列
 */
-(void)clearAll{
    [queueArray removeAllObjects];
    offSet = -1;
}

/**
 *  清空指定信息的数据
 */
-(void)clearAllRequestWithCenterl:(Request *)request{
    
    NSMutableIndexSet *indexsets = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i < queueArray.count; i++) {
        Request *need = [queueArray objectAtIndex:i];
        if (need.central == request.central) {
            [indexsets addIndex:i];
        }
    }
    [queueArray removeObjectsAtIndexes:indexsets];
    offSet = -1;
}

/**
 *  添加到队列中
 *
 *  @param request
 */
-(void)addQueue:(Request *)request{
    [queueArray addObject:request];
}

/**
 *  初始化数据
 *
 *  @param postData
 *  @param characteristic
 *  @param central
 */
-(void)initData:(NSData *)postData withCharacteristic:(CBMutableCharacteristic*)characteristic withCentral:(CBCentral *)central {
    
    if (queueArray==nil) {
        queueArray = [[NSMutableArray alloc] init];
    }
    
    //头
    Request *head = [self makeHead];
    head.pcharacteristic = characteristic;
    head.central = central;
    
    //中心数据
    [self makeMidData:[Tool compressData:postData] withCharacteristic:characteristic withCentral:central];
    
    //尾
    Request *foot = [self makeFooter];
    foot.pcharacteristic = characteristic;
    foot.central = central;
}


/**
 *  启动
 *
 *  @param peripheralManger 周边管理
 */
-(NSString *)star:(CBPeripheralManager *)peripheralManger{
    
    offSet = -1;
    if (queueArray.count > 0) {
        return [self next:peripheralManger];
    }
    return @"107队列数组为空异常";
}

/**
 *  下一个
 *  
 *  @param peripheralManger 周边管理
 */
-(NSString *)next:(CBPeripheralManager *)peripheralManger{
    
    offSet=offSet+1;
    if (offSet >= queueArray.count) {
        [self clearAll];
        return @"106清空队列信息";
    }
    //取出第offSet个Request
    Request *request = queueArray[offSet];
    NSString *result = [request updateValue:peripheralManger];
    
    //一旦发现数据分流异常，就讲此类型的数据全部清空
    if (result != nil) {
        //清空和 request 为空中心的所有数据信息
        //[self clearAllRequestWithCenterl:request];
        return result;
    }
    //发送成功的执行--判断是否是尾步
    if (request.type==2) {
        //则需要清空该段数据的信息
        [self clearAllRequestWithCenterl:request];
    }
    return nil;
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
    [[PerequestQueue shared] addQueue:request];
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
    [[PerequestQueue shared] addQueue:requestw];
    return requestw;
}

/**
 *  组合中间的数据
 *
 *  @param postData 上传的数据
 *  @param characteristic 周边信息
 *  @param central 目标中心设备
 */
-(void)makeMidData:(NSData *)postData withCharacteristic:(CBMutableCharacteristic*)characteristic withCentral:(CBCentral *)central {
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
        request.central = central;
        request.pcharacteristic = characteristic;
        [[PerequestQueue shared] addQueue:request];
    }
    //中心
}





@end
