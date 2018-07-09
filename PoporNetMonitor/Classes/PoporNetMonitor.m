//
//  PoporNetMonitor.m
//  PoporNetMonitor_Example
//
//  Created by popor on 2018/7/9.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporNetMonitor.h"

@implementation PoporNetMonitor

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

@end
