//
//  NSString+json.m
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import "NSString+json.h"

@implementation NSString (json)

-(NSDictionary *)Json{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return dic;
}


@end
