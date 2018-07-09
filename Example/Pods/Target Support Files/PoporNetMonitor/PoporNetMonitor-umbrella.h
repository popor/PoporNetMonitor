#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSURLSessionConfiguration+Swizzling.h"
#import "PoporNetMonitor.h"
#import "PoporUrlProtocol.h"

FOUNDATION_EXPORT double PoporNetMonitorVersionNumber;
FOUNDATION_EXPORT const unsigned char PoporNetMonitorVersionString[];

