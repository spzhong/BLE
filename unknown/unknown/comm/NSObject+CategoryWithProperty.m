//
//  NSObject+CategoryWithProperty.m
//  unknown
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 dachen. All rights reserved.
//

#import "NSObject+CategoryWithProperty.h"
#import <objc/runtime.h>

@implementation NSObject (CategoryWithProperty)


- (NSObject *)property {
    return objc_getAssociatedObject(self, @selector(property));
}

- (void)setProperty:(NSObject *)value {
    objc_setAssociatedObject(self, @selector(property), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
