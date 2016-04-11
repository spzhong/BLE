//
//  User+CoreDataProperties.h
//  unknown
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 dachen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *device;
@property (nullable, nonatomic, retain) NSString *isallow_xg;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *netType;
@property (nullable, nonatomic, retain) NSString *save_kb;
@property (nullable, nonatomic, retain) NSString *sell_kb;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *wifi;

@end

NS_ASSUME_NONNULL_END
