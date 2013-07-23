//
//  KCLogger.m
//  KCLogger
//
//  Created by Kevin Calloway on 7/15/13.
//  Copyright (c) 2013 Kevin Calloway. All rights reserved.
//

#import "KCLogger.h"

#import <libkern/OSAtomic.h>

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "KCContextBlacklistFilterLogFormatter.h"

static KCLogger *staticKCLogger = nil;
@implementation KCLogger
{
    NSUInteger totalViewedContexts;
	NSMutableDictionary *contexts;
}

+(void)start
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

+(void)stop
{
    [DDLog removeLogger:[DDASLLogger sharedInstance]];
    [DDLog removeLogger:[DDTTYLogger sharedInstance]];
}

-(NSArray *)allKnownContexts
{
    return [contexts allKeys];
}

-(id<DDLogFormatter>)blacklistFormatter
{
    return [[DDASLLogger sharedInstance] logFormatter];
}

-(void)registerContext:(const NSString *)contextName
{
    @synchronized(self)
	{
        if ([contexts objectForKey:contextName] == nil) {
            totalViewedContexts++;
            [contexts setObject:@(contexts.count) forKey:contextName];
        }
	}
}

-(void)blacklistContext:(const NSString *)contextName
{
    [self registerContext:contextName];
    NSNumber *contextId = [contexts objectForKey:contextName];
    KCContextBlacklistFilterLogFormatter *blacklistFormatter
        = [[DDASLLogger sharedInstance] logFormatter];
    [blacklistFormatter addToBlacklist:[contextId integerValue]];
}

-(void)unblacklistContext:(const NSString *)contextName
{
    NSNumber *contextId = [contexts objectForKey:contextName];
    if (contextId) {
        [contexts removeObjectForKey:contextName];
        KCContextBlacklistFilterLogFormatter *blacklistFormatter
            = [[DDASLLogger sharedInstance] logFormatter];

        [blacklistFormatter removeFromBlacklist:[contextId integerValue]];
    }
}

-(BOOL)isBlacklistedContext:(NSString *)loggingContext
{
	return ([contexts objectForKey:loggingContext] != nil);
}

-(id)initWithAllContexts:(NSMutableDictionary *)allContexts
{
    self = [super init];
    if (self) {
        contexts = allContexts;
    }

    return self;
}

+(KCLogger *)create
{
    static id<DDLogFormatter> blacklistFormatter = nil;
    if (blacklistFormatter == nil) {
        blacklistFormatter = [[KCContextBlacklistFilterLogFormatter alloc] init];

        //Add the formatter to the logger
        [[DDASLLogger sharedInstance] setLogFormatter:blacklistFormatter];
    }
    NSMutableDictionary *allContexts = [NSMutableDictionary dictionary];
    
    return [[KCLogger alloc] initWithAllContexts:allContexts];
}

+(KCLogger *)sharedInstance
{
    @synchronized(self)
	{
        if (staticKCLogger == nil) {
            staticKCLogger = [KCLogger create];
        }
    }
    return staticKCLogger;
}

@end
