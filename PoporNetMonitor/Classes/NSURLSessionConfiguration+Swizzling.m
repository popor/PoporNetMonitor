//
//  NSURLSessionConfiguration+Swizzling.m
//  PoporNetMonitor_Example
//
//  Created by popor on 2018/7/9.
//  Copyright © 2018年 popor. All rights reserved.
//
// 关键代码摘自 (https://github.com/HDB-Li/LLDebugTool)

#import "NSURLSessionConfiguration+Swizzling.h"

#import <objc/runtime.h>
#import <PoporFoundation/FunctionPrefix.h>

#import "PoporUrlProtocol.h"


@implementation NSURLSessionConfiguration (Swizzling)

+ (void)load{
    // 因为下面方法支持-方法,不支持+方法.
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        [[NSURLSessionConfiguration class] methodSwizzlingWithOriginalSelector:@selector(defaultSessionConfiguration)  bySwizzledSelector:@selector(zw_defaultSessionConfiguration)];
    //
    //        [NSURLProtocol registerClass:[ZanDNSProtocol class]];
    //    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (IsDebugVersion) {
            Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
            Method zwMethod = class_getClassMethod([self class], @selector(zw_defaultSessionConfiguration));
            method_exchangeImplementations(systemMethod, zwMethod);
            [NSURLProtocol registerClass:[PoporUrlProtocol class]];
        }
    });
}

+ (NSURLSessionConfiguration *)zw_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zw_defaultSessionConfiguration];
    NSArray *protocolClasses = @[[PoporUrlProtocol class]];
    configuration.protocolClasses = protocolClasses;
    
    return configuration;
}


@end
