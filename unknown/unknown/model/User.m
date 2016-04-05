//
//  User.m
//  unknown
//
//  Created by spzhong on 16/4/1.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "User.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_dic:(NSMutableDictionary *)dic{
    self.userId = dic[@"userId"];
    self.name = dic[@"name"];
    self.sell_kb = dic[@"sell_kb"];
    self.netType = dic[@"netType"];
    self.isallow_xg = dic[@"isallow_xg"];
    self.save_kb = dic[@"save_kb"];
    self.wifi = dic[@"wifi"];
    [CoreData save_coredata];
}

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_string:(NSString *)dicString{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[dicString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    self.userId = dic[@"userId"];
    self.name = dic[@"name"];
    self.sell_kb = dic[@"sell_kb"];
    self.netType = dic[@"netType"];
    self.isallow_xg = dic[@"isallow_xg"];
    self.save_kb = dic[@"save_kb"];
    self.wifi = dic[@"wifi"];
    [CoreData save_coredata];
}


/**
 *  转换成jsonstring
 *
 *  @return
 */
-(NSString *)exchangeJsonstring{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userId forKey:@"userId"];
    [dic setObject:self.name == nil ? @"":self.name forKey:@"name"];
    [dic setObject:self.sell_kb == nil ? @"":self.sell_kb forKey:@"sell_kb"];
    [dic setObject:self.netType  == nil? @"":self.netType forKey:@"netType"];
    [dic setObject:self.isallow_xg  == nil ? @"":self.isallow_xg forKey:@"isallow_xg"];
    [dic setObject:self.save_kb == nil ? @"":self.save_kb forKey:@"save_kb"];
    [dic setObject:self.wifi == nil ? @"":self.wifi forKey:@"wifi"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}


@end
