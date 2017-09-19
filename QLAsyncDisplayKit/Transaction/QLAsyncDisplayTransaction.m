//
//  QLAsyncDisplayTransaction.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayTransaction.h"
#import "QLAsyncDisplayOperation.h"
#import "QLAsyncDisplayTransactionGroup.h"
#import "NSObject+QLAsyncObjectExtra.h"
#import "QLAsyncDisplayLayer.h"

#  define ASDISPLAY_INLINE static inline

@interface QLAsyncDisplayTransaction ()

@property (nonatomic, strong) NSMutableArray<QLAsyncDisplayOperation *> *operations;

@property (nonatomic, copy) async_transaction_display_block_t displayBlock;
@property (nonatomic, copy) async_transaction_complete_block_t completeBlock;

@property (nonatomic, assign) QLAsyncDisplayTransactionState transactionState;

@property (nonatomic, strong) QLAsyncDisplayOperation *completeOperation;

@end

@implementation QLAsyncDisplayTransaction

+ (dispatch_queue_t)displayQueue
{
    static dispatch_queue_t displayQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayQueue = dispatch_queue_create("org.QLAsyncDisplayLayer.displayQueue", DISPATCH_QUEUE_CONCURRENT);
        // UI绘制的队列优先级要高于其他异步队列
        dispatch_set_target_queue(displayQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    
    return displayQueue;
}

- (id)init {
    if (self = [super init]) {
        _operations = [NSMutableArray array];
        
        self.transactionState = QLAsyncDisplayTransactionStateOpen;
    }
    
    return self;
}

+ (QLAsyncDisplayTransaction *)transactionWithDisplayBlock:(async_transaction_display_block_t)displayBlock completeBlock:(async_transaction_complete_block_t)completeBlock {
    QLAsyncDisplayTransaction *transaction = [[QLAsyncDisplayTransaction alloc] init];
    transaction.displayBlock =  displayBlock;
    transaction.completeBlock = completeBlock;
    
    __weak typeof(transaction) weakSelf = transaction;
    dispatch_async([QLAsyncDisplayTransaction displayQueue], ^{
        if (weakSelf.transactionState == QLAsyncDisplayTransactionStateCanceled) {
            return;
        }
        
        weakSelf.transactionState = QLAsyncDisplayTransactionStateCommitted;
        
        UIImage *resultImage = weakSelf.displayBlock();
        
        weakSelf.completeOperation = [[QLAsyncDisplayOperation alloc] initWithOperationCompletionBlock:^(UIImage *value) {
            weakSelf.completeBlock(value);
            
            weakSelf.transactionState = QLAsyncDisplayTransactionStateHasCompleted;
        }];
        
        weakSelf.completeOperation.value = resultImage;
        
        weakSelf.transactionState = QLAsyncDisplayTransactionStateHasValue;
        
    });
    
    QLAsyncDisplayTransactionGroup *group = [QLAsyncDisplayTransactionGroup shareInstance];
    [group addTransaction:transaction];
    
    return transaction;
}

- (void)commit {
    
    if (self.transactionState == QLAsyncDisplayTransactionStateCanceled || self.transactionState == QLAsyncDisplayTransactionStateHasCompleted) {
        return;
    }
    
    if (self.transactionState != QLAsyncDisplayTransactionStateHasValue) {
        QLAsyncDisplayTransactionGroup *group = [QLAsyncDisplayTransactionGroup shareInstance];
        [group addTransaction:self];
        
        return;
    }
    
    if (self.completeOperation) {
        [self.completeOperation commit];
    }
}

- (void)cancelDisplay {
    self.transactionState = QLAsyncDisplayTransactionStateCanceled;
}

@end
