//
//  KCLoggerTests.m
//  KCLoggerTests
//
//  Created by Kevin Calloway on 7/15/13.
//  Copyright (c) 2013 Kevin Calloway. All rights reserved.
//

#import "KCLoggerTests.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#define kTestContext1 @"Hamburgers"
#define kTestContext2 @"CumQuat Quiche"
SET_DEFAULT_LOG_LEVEL(LOGGING_LEVEL_ERROR)
SET_DEFAULT_FILE_CONTEXT(kTestContext1)

@implementation KCLoggerTests

- (void)setUp
{
    [super setUp];

    [KCLogger start];
    testLogger = [KCLogger sharedInstance];
}

- (void)tearDown
{
    [DDLog flushLog];
    [DDLog removeAllLoggers];

    [super tearDown];
}

-(void)testRegisterContext
{
    //Run Test
    [testLogger registerContext:kTestContext1];
    //We'll make sure that we can't add it twice
    [testLogger registerContext:kTestContext1];

    NSString *onlyContext = [[testLogger allKnownContexts] objectAtIndex:0];

    //Verify Results
    NSAssert([kTestContext1 isEqualToString:onlyContext],
             @"We expected the context %@, but instead got %@",
             kTestContext1, onlyContext);
    NSInteger count = [testLogger allKnownContexts].count;
    NSAssert(count == 1, @"We expected 1 context, but instead got %d", count);
}

-(void)testUnBlacklistContext
{
    //Run Test
    [testLogger registerContext:kTestContext1];
    [testLogger unblacklistContext:kTestContext1];

    //Verify Results
    NSInteger count = [testLogger allKnownContexts].count;
    NSAssert(count == 0, @"We expected no contexts, but instead got %d", count);
}

- (void)testLoggerDoesFilter
{
    [[KCLogger sharedInstance] blacklistContext:kTestContext1];
    KCLogError(@"Should see");
    KCLogWarn(@"Should See 2");

    KCLogVerbose(@"Should Never See");
}

//- (void)testpLoggerDoesFilter
//{
//    SET_LOCAL_SCOPE_CONTEXT(kTestContext2)
//    [[KCLogger sharedInstance] blacklistContext:kTestContext1];
//    KCLogError(@"Should see");
//    KCLogVerbose(@"AAAAA");
//}

@end
