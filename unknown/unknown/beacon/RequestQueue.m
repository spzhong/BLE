//
//  RequestQueue.m
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "RequestQueue.h"

@implementation Request



@end


@implementation RequestQueue


static RequestQueue *queue = nil;
static NSMutableArray *queueArray;//队列数组
static long offSet;

/**
 *  创建一个队列单例
 *
 *  @return self
 */
+(id)shared{
    if (queue==nil) {
        queue = [[RequestQueue alloc] init];
        queueArray = [[NSMutableArray alloc] init];
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
 *  添加到队列中
 *
 *  @param request
 */
-(void)addQueue:(Request *)request{
    [queueArray addObject:request];
}


/**
 *  启动
 */
-(Request *)star{
    offSet = 0;
    if (queueArray.count > 0) {
        return queueArray[offSet];
    }
    return nil;
}

/**
 *  启动
 */
-(Request *)next{
    offSet=offSet+1;
    if (offSet >= queueArray.count) {
        [self clearAll];
        return nil;
    }
    //取出第offSet个Request
    return queueArray[offSet];
}





@end
