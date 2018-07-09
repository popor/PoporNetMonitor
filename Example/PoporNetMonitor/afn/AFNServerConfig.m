//
//  NetServerConfig.m
//  linRunShengPi
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import "AFNServerConfig.h"

#define SHARE_INSTANCE_WANZI \
+ (id)sharedInstance \
{\
static dispatch_once_t once;\
static id instance;\
dispatch_once(&once, ^{instance = [self new];});\
return instance;\
}

@implementation AFNServerConfig

// 有内存泄露问题弃用
//+ (instancetype)share {
//    static dispatch_once_t once;
//    static AFNServerConfig * instance;
//    dispatch_once(&once, ^{
//        instance = [self new];
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//        manager.requestSerializer =  [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
//
//        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//        manager.requestSerializer.timeoutInterval = 10.0f;
//
//        instance.manager = manager;
//    });
//    return instance;
//}

+ (AFHTTPSessionManager *)createManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
    
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"system"];
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    return manager;
}

@end

