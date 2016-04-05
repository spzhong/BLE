//
//  QiNiu.h
//  unknown
//
//  Created by spzhong on 16/3/11.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"


/**
 *  七牛返回的状态
 *
 *  @param backState
 */
typedef void (^QNOneBack)(NSMutableDictionary *backState);

typedef void (^QNAllBack)(BOOL isAll);

@interface QiNiu : NSObject

/**
 *  上传文件和数据
 *
 *  @param filePathArray 数组类型的字典{key,data,state}
 *  @param oneback       每次上传成功后的回调
 *  @param allBack       所有的上传的结果后的回调
 */
+(void)upAllDataFiles:(NSMutableArray *)filePathArray withBack:(QNOneBack)oneback withAllBack:(QNAllBack)allBack;



@end
