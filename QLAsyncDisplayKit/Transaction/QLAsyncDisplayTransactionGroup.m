//
//  QLAsyncDisplayTractionGroup.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayTransactionGroup.h"
#import "QLAsyncDisplayTransaction.h"

static void __transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

@interface QLAsyncDisplayTransactionGroup ()

@property (nonatomic, strong) NSHashTable<QLAsyncDisplayTransaction *> *tranctions;

@end

@implementation QLAsyncDisplayTransactionGroup

+ (instancetype)shareInstance
{
    static QLAsyncDisplayTransactionGroup *mainGroup = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainGroup = [[QLAsyncDisplayTransactionGroup alloc] init];
        
        [QLAsyncDisplayTransactionGroup registerTransactionGroupAsMainRunloopObserver:mainGroup];
    });

    return mainGroup;
}

+ (void)registerTransactionGroupAsMainRunloopObserver:(QLAsyncDisplayTransactionGroup *)transactionGroup
{
    static CFRunLoopObserverRef observer;
  
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
                                kCFRunLoopExit);          // before exiting a runloop run
    CFRunLoopObserverContext context = {
        0,           // version
        (__bridge void *)transactionGroup,  // info
        &CFRetain,   // retain
        &CFRelease,  // release
        NULL         // copyDescription
    };
    
    observer = CFRunLoopObserverCreate(NULL,        // allocator
                                       activities,  // activities
                                       YES,         // repeats
                                       INT_MAX,     // order after CA transaction commits
                                       &__transactionGroupRunLoopObserverCallback,  // callback
                                       &context);   // context
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (instancetype)init
{
    if ((self = [super init])) {
        _tranctions = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
    }
    return self;
}

- (void)addTransaction:(QLAsyncDisplayTransaction *)transaction
{
    [_tranctions addObject:transaction];
}

- (void)commit
{
    if ([_tranctions count]) {
        NSHashTable *tractionsToCommit = _tranctions;
        _tranctions = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
        
        for (QLAsyncDisplayTransaction *transaction in tractionsToCommit) {
            [transaction commit];
        }
    }
}

static void __transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    QLAsyncDisplayTransactionGroup *group = (__bridge QLAsyncDisplayTransactionGroup *)info;
    [group commit];
}

@end
