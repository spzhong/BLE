//
//  User.m
//  unknown
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import "User.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

/**
 *  初始化数据
 *
 *  @param dataString
 */
-(void)initData_dic:(NSDictionary *)dic{
    self.userId = dic[@"userId"];
    self.name = dic[@"name"];
    self.sell_kb = dic[@"sell_kb"];
    self.netType = dic[@"netType"];
    self.isallow_xg = dic[@"isallow_xg"];
    self.save_kb = dic[@"save_kb"];
    self.wifi = dic[@"wifi"];
    self.device = dic[@"device"];
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
    self.device = dic[@"device"];
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
    [dic setObject:self.device == nil ? @"":self.device forKey:@"device"];
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@"100" forKey:@"code"];
    [postDic setObject:[Tool interface:@"100"] forKey:@"msg"];
    [postDic setObject:dic forKey:@"data"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return myString;
}

@end
