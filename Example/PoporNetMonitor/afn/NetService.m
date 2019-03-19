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

//#import <PoporNetRecord/PoporNetRecord.h>
//#import <PoporFoundation/PrefixFun.h>
//static NSString * MethodGet  = @"GET";
//static NSString * MethodPost = @"POST";

//如何添加head.
//https://www.jianshu.com/p/c741236c5c30

@implementation NetService

+ (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure
{
    [self postUrl:urlString title:nil afnManager:nil parameters:parameters success:success failure:failure];
}

+ (void)postUrl:(NSString *_Nullable)urlString
          title:(NSString *_Nullable)title
     afnManager:(AFHTTPSessionManager * _Nullable)manager
     parameters:(NSDictionary * _Nullable)parameters
        success:(PoporAFNFinishBlock _Nullable )success
        failure:(PoporAFNFailureBlock _Nullable)failure
{
    [PoporAFNTool postUrl:urlString title:title parameters:parameters afnManager:manager success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
        if ([NetService checkUrl:urlString dic:dic]) {
            if (success) {
                success(url, data, dic);
            }
        }
    } failure:failure];
}

+ (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure
{
    [self getUrl:urlString title:nil afnManager:nil parameters:parameters success:success failure:failure];
}

+ (void)getUrl:(NSString *_Nullable)urlString title:(NSString *_Nullable)title afnManager:(AFHTTPSessionManager * _Nullable)manager parameters:(NSDictionary * _Nullable)parameters success:(PoporAFNFinishBlock _Nullable )success failure:(PoporAFNFailureBlock _Nullable)failure
{
    [PoporAFNTool getUrl:urlString title:title parameters:parameters afnManager:manager success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
        if ([NetService checkUrl:urlString dic:dic]) {
            if (success) {
                success(url, data, dic);
            }
        }
    } failure:failure];
}

// 系统更新的和被踢下线的,返回NO.
+ (BOOL)checkUrl:(NSString *_Nullable)urlString dic:(NSDictionary *)dic {
    if (dic) {
        
    }
    return YES;
}

@end
