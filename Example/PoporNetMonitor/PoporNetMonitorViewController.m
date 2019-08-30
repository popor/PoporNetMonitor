//
//  PoporNetMonitorViewController.m
//  PoporNetMonitor
//
//  Created by wangkq on 07/06/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporNetMonitorViewController.h"

#import "NetService.h"
#import <PoporNetMonitor/PoporNetMonitor.h>
#import <PoporNetRecord/PoporNetRecord.h>

#import <PoporFoundation/NSString+pTool.h>
#import <PoporFoundation/NSDictionary+pTool.h>

@interface PoporNetMonitorViewController ()

@end

@implementation PoporNetMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PnrConfig * config =[PnrConfig share];
    config.webRootTitle = @"林润审批";
    config.recordType = PoporNetRecordEnable;
    // 网页ico
    NSString *path = [[NSBundle mainBundle] pathForResource:@"favicon" ofType:@"ico"];
    NSData *data   = [[NSData alloc] initWithContentsOfFile:path];
    config.webIconData = data;
    // 设置pnr nc样式
    config.presentNCBlock = ^(UINavigationController *nc) {
        //[nc setVRSNCBarTitleColor];
    };
    [self setPnrResubmit];
    
    // 1.通过修改 NSURLProtocol实现监测.
    [PoporNetMonitor share].monitor = YES;
    
    // 2.通过自定义工具监测.
    [NetService getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil];
    [NetService postUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil];
    //    [NetServiceTool getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
    //    [NetServiceTool postUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
    //
    
}

- (void)setPnrResubmit {
    [PoporNetRecord setPnrBlockResubmit:^(NSDictionary * _Nonnull formDic, PnrBlockFeedback  _Nonnull blockFeedback) {
        NSString * urlStr       = formDic[@"url"];
        NSString * methodStr    = formDic[@"method"];
        NSString * headStr      = formDic[@"head"];
        NSString * parameterStr = formDic[@"parameter"];
        //NSString * extraStr     = formDic[@"extra"];
        NSString * title        = @"-可以修改-";
        
        AFHTTPSessionManager * manager = [self managerDic:headStr.toDic];
        
        if ([methodStr.lowercaseString isEqualToString:@"get"]) {
            [NetService getUrl:urlStr title:title afnManager:manager parameters:parameterStr.toDic success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
                if (dic) {
                    blockFeedback(dic.toJsonString);
                }else{
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    blockFeedback(str);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                blockFeedback(error.localizedDescription);
            }];
        }else if ([methodStr.lowercaseString isEqualToString:@"post"]) {
            [NetService postUrl:urlStr title:title afnManager:manager parameters:parameterStr.toDic success:^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
                if (dic) {
                    blockFeedback(dic.toJsonString);
                }else{
                    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    blockFeedback(str);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                blockFeedback(error.localizedDescription);
            }];
        }
    } extraDic:nil];
    
}

- (AFHTTPSessionManager *)managerDic:(NSDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
    
    NSArray * keyArray = dic.allKeys;
    for (NSString * key in keyArray) {
        [manager.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    return manager;
}


@end
