//
//  User.h
//  unknown
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_dic:(NSDictionary *)dic;

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
