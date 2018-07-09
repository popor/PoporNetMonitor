//
//  NetService.h
//  NetService
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NetServiceFinishBlock)(NSString *url, NSData *data, NSDictionary *dic);
typedef void(^NetServiceFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

#define NetServiceTool [[NetService alloc] init]

@interface NetService : NSObject

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure;

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure;

- (void)postUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure monitor:(BOOL)monitor;

- (void)getUrl:(NSString *_Nullable)urlString parameters:(NSDictionary * _Nullable)parameters success:(NetServiceFinishBlock _Nullable )success failure:(NetServiceFailureBlock _Nullable)failure monitor:(BOOL)monitor;

@end

NS_ASSUME_NONNULL_END
