//
//  KCLogger.h
//  KCLogger
//
//  Created by Kevin Calloway on 7/15/13.
//  Copyright (c) 2013 Kevin Calloway. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_FLAG_ALWAYS_SHOW        (1 << 4)  // 0...010000
#define LOG_FLAG_PERSIST_TO_SERVER  (1 << 5)  // 0...100000
#define LOGGING_FLAG_ERROR    (LOG_FLAG_ERROR | LOG_FLAG_ALWAYS_SHOW | LOG_FLAG_PERSIST_TO_SERVER)  // 0...0001
#define LOGGING_FLAG_WARN     (LOG_FLAG_WARN | LOG_FLAG_ALWAYS_SHOW)       // 0...0010
#define LOGGING_FLAG_INFO     (LOG_FLAG_INFO | LOG_FLAG_PERSIST_TO_SERVER) // 0...0100
#define LOGGING_FLAG_VERBOSE  (LOG_FLAG_VERBOSE)                           // 0...1000

#define LOGGING_LEVEL_ERROR   LOGGING_FLAG_ERROR                                   // 0...0001
#define LOGGING_LEVEL_WARN    (LOG_FLAG_ERROR | LOGGING_FLAG_WARN)                 // 0...0011
#define LOGGING_LEVEL_INFO    (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOGGING_FLAG_INFO) // 0...0111
#define LOGGING_LEVEL_VERBOSE (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO | LOGGING_FLAG_VERBOSE) // 0...1111

#define SET_DEFAULT_LOG_LEVEL(logLevel)      static const int ddLogLevel = logLevel;
#define SET_DEFAULT_FILE_CONTEXT(logContext) static const NSString *ddLogContext = logContext;
//#define SET_LOCAL_SCOPE_CONTEXT(logContext)  ddLogContext = logContext;

#define KCLogError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   ddLogLevel, LOGGING_FLAG_ERROR,   (int)ddLogContext, frmt, ##__VA_ARGS__)
#define KCLogWarn(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    ddLogLevel, LOGGING_FLAG_WARN,    (int)ddLogContext, frmt, ##__VA_ARGS__)
#define KCLogInfo(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    ddLogLevel, LOGGING_FLAG_INFO,    (int)ddLogContext, frmt, ##__VA_ARGS__)
#define KCLogVerbose(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, ddLogLevel, LOGGING_FLAG_VERBOSE, (int)ddLogContext, frmt, ##__VA_ARGS__)

@interface KCLogger : NSObject
+(void)start;
-(NSArray *)allKnownContexts;
-(void)registerContext:(const NSString *)contextName;
-(void)blacklistContext:(const NSString *)contextName;
-(void)unblacklistContext:(const NSString *)contextName;
-(BOOL)isBlacklistedContext:(const NSString *)loggingContext;

#pragma mark Create
+(KCLogger *)sharedInstance;

@end
