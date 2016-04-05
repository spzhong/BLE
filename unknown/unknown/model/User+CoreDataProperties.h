//
//  User+CoreDataProperties.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;       //用户的ID
@property (nullable, nonatomic, retain) NSString *name;         //用户的名称
@property (nullable, nonatomic, retain) NSString *sell_kb;      //愿意出售多少的流量
@property (nullable, nonatomic, retain) NSString *netType;      //网络类型（网络类型）
@property (nullable, nonatomic, retain) NSString *isallow_xg;   //是否允许在3G,4G下允许被人访问
@property (nullable, nonatomic, retain) NSString *save_kb;      //一共节省了多少流量
@property (nullable, nonatomic, retain) NSString *wifi;         //当前的wifi名称

@end

NS_ASSUME_NONNULL_END
