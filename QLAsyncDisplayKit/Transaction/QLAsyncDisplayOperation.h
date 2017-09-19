//
//  QLAsyncDisplayOperation.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^async_transaction_operation_completion_block_t)(UIImage *value);

@interface QLAsyncDisplayOperation : NSObject

@property (nonatomic, strong) UIImage *value;

@property (nonatomic, copy) async_transaction_operation_completion_block_t completeBlock;

- (instancetype)initWithOperationCompletionBlock:(async_transaction_operation_completion_block_t)completionBlock;

- (void)commit;

@end
