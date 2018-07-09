//
//  PoporNetMonitorViewController.m
//  PoporNetMonitor
//
//  Created by wangkq on 07/06/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporNetMonitorViewController.h"

#import "NetService.h"

@interface PoporNetMonitorViewController ()

@end

@implementation PoporNetMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [NetServiceTool getUrl:@"https://github.com/popor/PoporNetMonitor" parameters:nil success:nil failure:nil monitor:YES];
    
}


@end
