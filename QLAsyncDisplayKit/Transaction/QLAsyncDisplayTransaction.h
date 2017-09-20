//
//  QLAsyncDisplayTransaction.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLAsyncDisplayObjectParamters.h"

typedef NS_ENUM(NSUInteger, QLAsyncDisplayTransactionState) {
    QLAsyncDisplayTransactionStateOpen = 0,    //打开，可以被执行
    QLAsyncDisplayTransactionStateCanceled = 1, //事务被取消
    QLAsyncDisplayTransactionStateCommitted = 2, //绘制任务已提交
    QLAsyncDisplayTransactionStateHasValue = 3, //绘制已完成
    QLAsyncDisplayTransactionStateHasCompleted = 4, //事务已完成
};

typedef UIImage* (^async_transaction_display_block_t)(void);

typedef void(^async_transaction_complete_block_t)(UIImage *image);

@class QLAsyncDisplayLayer;

@interface QLAsyncDisplayTransaction : NSObject

+ (QLAsyncDisplayTransaction *)transactionWithDisplayBlock:(async_transaction_display_block_t)displayBlock completeBlock:(async_transaction_complete_block_t)completeBlock;

- (void)commit;

- (void)cancelDisplay;

@end
