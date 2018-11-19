//
//  PoporUrlProtocol.h
//  PoporNetMonitor_Example
//
//  Created by popor on 2018/7/9.
//  Copyright © 2018年 popor. All rights reserved.
//

// 关键代码摘自 (https://github.com/HDB-Li/LLDebugTool)
// 只开启了debug模式,release模式没有开启.

#import <Foundation/Foundation.h>

@interface PoporUrlProtocol : NSURLProtocol

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSMutableData        *data;
@property (nonatomic, strong) NSDate               *startDate;
@property (nonatomic, strong) NSError              *error;

- (void)netMonitorRecordDefaultEvent;

@end
