//
//  NetServerConfig.h
//  linRunShengPi
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNServerConfig : NSObject

+ (AFHTTPSessionManager *)createManager;

@end

