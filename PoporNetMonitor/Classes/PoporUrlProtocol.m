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

@end

@implementation PoporUrlProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    if ([NSURLProtocol propertyForKey:HTTPHandledIdentifier inRequest:request] ) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:HTTPHandledIdentifier inRequest:mutableReqeust];
    return mutableReqeust;
}

- (void)startLoading
{
    //NSLog(@"%s", __func__);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.startDate = [NSDate date];
    self.data      = [NSMutableData data];
    
    self.session   = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.dataTask  = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)stopLoading
{
    //NSLog(@"%s", __func__);
    [self.dataTask cancel];
    self.dataTask = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([PoporNetMonitor share].isMonitor) {
            if ([PoporNetMonitor share].recordCustomBlock) {
                [PoporNetMonitor share].recordCustomBlock(self);
            }else{
                [self netMonitorRecordDefaultEvent];
            }
        }
    });
}

- (void)netMonitorRecordDefaultEvent {
    if (self.data) {
        NSDictionary * dic = [self.data toDic];
        if (dic) {
            [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields parameter:[self.request.HTTPBody toDic] response:dic];
        }else{
            NSString * str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
            if (str) {
                [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields parameter:[self.request.HTTPBody toDic] response:str];
            }else{
                [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields parameter:[self.request.HTTPBody toDic] response:nil];
            }
        }
        
    }else{
        [PoporNetRecord addUrl:self.request.URL.absoluteString method:self.request.HTTPMethod head:self.request.allHTTPHeaderFields parameter:[self.request.HTTPBody toDic] response:@{@"异常":@"null"}];
    }
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

