//
//  QiNiu.m
//  unknown
//
//  Created by spzhong on 16/3/11.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "QiNiu.h"

@implementation QiNiu

/**
 *  七牛返回的状态
 *
 *  @param key
 *  @param state  0是成功，1是失败，2是超时
 */
typedef void (^QNBack)(NSString *key, int state);



/**
 *  上传文件和数据
 *
 *  @param filePathArray 数组类型的字典{key,data,state}
 *  @param oneback       每次上传成功后的回调
 *  @param allBack       所有的上传的结果后的回调
 */
+(void)upAllDataFiles:(NSMutableArray *)filePathArray withBack:(QNOneBack)oneback withAllBack:(QNAllBack)allBack{
    NSInteger allCount = filePathArray.count;
    __block int ii = 0;
    for (NSMutableDictionary *dic in filePathArray) {
        NSString *key = dic[@"key"];
        if ([dic[@"data"] isKindOfClass:[NSString class]]) {
            NSString *data = dic[@"data"];
            [QiNiu upFile:key withData:data withBack:^(NSString *key, int state){
                [dic setObject:[NSString stringWithFormat:@"%d",state] forKey:@"state"];
                if (state==0) {
                    ii++;
                    oneback(dic);
                }
                //所有的都上传了哦
                if (ii == allCount) {
                    allBack(YES);
                }else{
                    allBack(NO);
                }
            }];
        }else{
            NSData *data = dic[@"data"];
            [QiNiu upData:key withData:data withBack:^(NSString *key, int state){
                [dic setObject:[NSString stringWithFormat:@"%d",state] forKey:@"state"];
                if (state==0) {
                    ii++;
                    oneback(dic);
                }
                //所有的都上传了哦
                if (ii == allCount) {
                    allBack(YES);
                }else{
                    allBack(NO);
                }
            }];
        }
    }
    
}


/**
 *  上传数据
 *
 *  @param key  文件
 *  @param data 数据
 */
+(void)upData:(NSString *)key withData:(NSData *)data withBack:(QNBack)back{
    NSString *token = @"从服务端SDK获取";
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
              } option:nil];
}



/**
 *  上传单个文件
 *
 *  @param key  文件
 *  @param data 数据
 */
+(void)upFile:(NSString *)key withData:(NSString *)filePath withBack:(QNBack)back{
    NSString *token = @"从服务端SDK获取";
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
        
    } option:nil];
}



@end
