//
//  CentralData.h
//  unknown
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"


/**
 *  周边设备接收到中心设备存放的数据model
 */
@interface CentralData : NSObject{
    
}

@property(nonatomic,strong)User *aUser;//中心用户设备信息
@property(nonatomic,strong)NSMutableData *allData;//发送的数据

@end
