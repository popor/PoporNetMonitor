//
//  NetService.h
//  NetService
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PoporAFN/PoporAFN.h>

NS_ASSUME_NONNULL_BEGIN

#define NetServiceTool [[NetService alloc] init]

@interface NetService : NSObject

+ (void)postUrl:(NSString *_Nullable)urlString
     parameters:(NSDictionary * _Nullable)parameters
        success:(PoporAFNFinishBlock _Nullable )success
        failure:(PoporAFNFailureBlock _Nullable)failure;

+ (void)postUrl:(NSString *_Nullable)urlString
          title:(NSString *_Nullable)title
     afnManager:(AFHTTPSessionManager * _Nullable)manager
     parameters:(NSDictionary * _Nullable)parameters
        success:(PoporAFNFinishBlock _Nullable )success
        failure:(PoporAFNFailureBlock _Nullable)failure;

+ (void)getUrl:(NSString *_Nullable)urlString
    parameters:(NSDictionary * _Nullable)parameters
       success:(PoporAFNFinishBlock _Nullable )success
       failure:(PoporAFNFailureBlock _Nullable)failure;

+ (void)getUrl:(NSString *_Nullable)urlString
         title:(NSString *_Nullable)title
    afnManager:(AFHTTPSessionManager * _Nullable)manager
    parameters:(NSDictionary * _Nullable)parameters
       success:(PoporAFNFinishBlock _Nullable )success
       failure:(PoporAFNFailureBlock _Nullable)failure;

@end

NS_ASSUME_NONNULL_END
