//
//  PoporUrlProtocol.m
//  PoporNetMonitor_Example
//
//  Created by popor on 2018/7/9.
//  Copyright © 2018年 popor. All rights reserved.
//
// 关键代码摘自 (https://github.com/HDB-Li/LLDebugTool)

#import "PoporUrlProtocol.h"
#import <PoporNetRecord/PoporNetRecord.h>
#import <PoporFoundation/NSData+dic.h>

#import "PoporNetMonitor.h"

static NSString *const HTTPHandledIdentifier = @"HttpHandleIdentifier";

@interface PoporUrlProtocol () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSMutableData        *data;
@property (nonatomic, strong) NSDate               *startDate;
@property (nonatomic, strong) NSError              *error;


@end

@implementation PoporUrlProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:HTTPHandledIdentifier inRequest:request] ) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:HTTPHandledIdentifier
                     inRequest:mutableReqeust];
    //    return [mutableReqeust copy];
    return mutableReqeust;
}


- (void)startLoading {
    NSLog(@"%s", __func__);
    self.startDate                           = [NSDate date];
    self.data                                = [NSMutableData data];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session                             = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.dataTask                            = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)stopLoading {
    NSLog(@"%s", __func__);
    
    [self.dataTask cancel];
    self.dataTask           = nil;
    
    if ([PoporNetMonitor share].isMonitor) {
        
        if (self.data) {
            [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields request:[self.request.HTTPBody toDic] response:[self.data toDic]];
            
        }else{
            [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields request:[self.request.HTTPBody toDic] response:@{@"异常":@"null"}];
        }
        
    }
    
    //    LLNetworkModel *model = [[LLNetworkModel alloc] init];
    //    model.startDate = [[LLTool sharedTool] stringFromDate:self.startDate];
    //    model.url = self.request.URL;
    //    model.method = self.request.HTTPMethod;
    //    model.headerFields = self.request.allHTTPHeaderFields;
    //    model.mineType = self.response.MIMEType;
    //    if (self.request.HTTPBody) {
    //        model.requestBody = [LLTool prettyJSONStringFromData:self.request.HTTPBody];
    //    } else if (self.request.HTTPBodyStream) {
    //        NSData* data = [self dataFromInputStream:self.request.HTTPBodyStream];
    //        model.requestBody = [LLTool prettyJSONStringFromData:data];
    //    }
    //    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    //    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    //    model.responseData = self.data;
    //    if (self.response.MIMEType) {
    //        model.isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    //    }
    //    NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
    //    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
    //        model.isImage = YES;
    //    }
    //    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    //    model.error = self.error;
    //    [[LLStorageManager sharedManager] saveNetworkModel:model];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    self.error = error;
    self.dataTask = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}

@end
