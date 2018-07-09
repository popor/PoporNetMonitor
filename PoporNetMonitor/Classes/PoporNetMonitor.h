//
//  PoporNetMonitor.h
//  PoporNetMonitor_Example
//
//  Created by popor on 2018/7/9.
//  Copyright © 2018年 popor. All rights reserved.
//
// 关键代码摘自 (https://github.com/HDB-Li/LLDebugTool)
// 只开启了debug模式,release模式没有开启.

#import <Foundation/Foundation.h>

@interface PoporNetMonitor : NSObject

@property (nonatomic, getter=isMonitor) BOOL monitor;

+ (instancetype)share;

@end
