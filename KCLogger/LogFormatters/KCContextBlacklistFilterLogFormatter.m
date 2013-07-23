//
//  KCContextBlacklistFilterLogFormatter.m
//  KCLogger
//
//  Created by Kevin Calloway on 7/22/13.
//  Copyright (c) 2013 Kevin Calloway. All rights reserved.
//

#import "KCContextBlacklistFilterLogFormatter.h"
#import "KCLogger.h"

@implementation KCContextBlacklistFilterLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *loggingContext = (__bridge NSString *)((void *)logMessage->logContext);
    if ([self isBlacklistedContext:loggingContext])
		return nil;
	else
		return logMessage->logMsg;
}

- (BOOL)isBlacklistedContext:(NSString *)loggingContext
{
	return [[KCLogger sharedInstance]
            isBlacklistedContext:loggingContext];
}

@end
