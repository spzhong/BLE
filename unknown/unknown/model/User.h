//
//  User.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData.h"


NS_ASSUME_NONNULL_BEGIN


@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_dic:(NSMutableDictionary *)dic;

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_string:(NSString *)dicString;
    
/**
 *  转换成jsonstring
 *
 *  @return
 */
-(NSString *)exchangeJsonstring;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
