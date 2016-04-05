//
//  Scan+CoreDataProperties.h
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Scan.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scan (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *sId;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *timeLog;
@property (nullable, nonatomic, retain) NSString *notifyUser;

@end

NS_ASSUME_NONNULL_END
