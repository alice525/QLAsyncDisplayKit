//
//  QLAsyncDisplayTractionGroup.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QLAsyncDisplayTransaction;

@interface QLAsyncDisplayTransactionGroup : NSObject

+ (instancetype)shareInstance;

- (void)addTransaction:(QLAsyncDisplayTransaction *)transaction;

- (void)commit;

@end
