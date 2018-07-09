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

@interface PoporNetMonitorViewController ()

@end

@implementation PoporNetMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.通过修改 NSURLProtocol实现监测.
    [PoporNetMonitor share].monitor = YES;
    
    // 2.通过自定义工具监测.
    [NetServiceTool getUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
    [NetServiceTool postUrl:@"https://api.androidhive.info/volley/person_object.json" parameters:@{@"test":@"test1"} success:nil failure:nil monitor:YES];
}


@end
