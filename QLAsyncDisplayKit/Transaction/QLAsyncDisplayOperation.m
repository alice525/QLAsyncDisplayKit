//
//  QLAsyncDisplayOperation.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayOperation.h"

@implementation QLAsyncDisplayOperation

- (instancetype)initWithOperationCompletionBlock:(async_transaction_operation_completion_block_t)completionBlock
{
    if ((self = [super init])) {
        _completeBlock = completionBlock;
    }
    return self;
}

- (void)commit {
    self.completeBlock(self.value);
}

@end
