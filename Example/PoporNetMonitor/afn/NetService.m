//
//  NetService.m
//  NetService
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import "NetService.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNServerConfig.h"
#import <PoporNetRecord/PoporNetRecord.h>

//如何添加head.
//https://www.jianshu.com/p/c741236c5c30

@interface NetService ()

//@property (nonatomic, strong) NSURLSessionDataTask * task;

@end

@implementation NetService

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure {
    [self postUrl:urlString parameters:parameters success:success failure:failure monitor:YES];
}

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure {
    [self getUrl:urlString parameters:parameters success:success failure:failure monitor:YES];
}

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure monitor:(BOOL)monitor {
    
    NSString * method = @"POST";
    AFHTTPSessionManager *manager = [AFNServerConfig createManager];
    __weak typeof(manager) weakManager = manager;
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetService successManager:weakManager url:urlString method:method parameters:parameters task:task response:responseObject success:success monitor:monitor];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NetService failManager:weakManager url:urlString method:method parameters:parameters task:task error:error failure:failure monitor:monitor];
    }];
}

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure monitor:(BOOL)monitor {
    
    NSString * method = @"GET";
    AFHTTPSessionManager *manager = [AFNServerConfig createManager];
    __weak typeof(manager) weakManager = manager;
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NetService successManager:weakManager url:urlString method:method parameters:parameters task:task response:responseObject success:success monitor:monitor];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NetService failManager:weakManager url:urlString method:method parameters:parameters task:task error:error failure:failure monitor:monitor];
    }];
}

+ (void)successManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task response:(id _Nullable) responseObject success:(NetServiceFinishBlock _Nullable )success monitor:(BOOL)monitor {
    [manager invalidateSessionCancelingTasks:YES];
    
    //NSString * res = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic;
        if (responseObject) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (monitor) {
            [PoporNetRecord addUrl:urlString method:method head:manager.requestSerializer.HTTPRequestHeaders request:parameters response:dic];
        }
        
        if (success) {
            success(urlString, responseObject, dic);
        }
    });
}

+ (void)failManager:(AFHTTPSessionManager *)manager url:(NSString *)urlString method:(NSString *)method parameters:(NSDictionary * _Nullable)parameters task:(NSURLSessionDataTask * _Nullable)task error:(NSError *)error failure:(NetServiceFailureBlock _Nullable)failure monitor:(BOOL)monitor {
    [manager invalidateSessionCancelingTasks:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failure) {
            failure(task, error);
        }
        if (monitor) {
            [PoporNetRecord addUrl:urlString method:method head:manager.requestSerializer.HTTPRequestHeaders request:parameters response:@{@"异常":error.localizedDescription}];
        }
    });
}

@end