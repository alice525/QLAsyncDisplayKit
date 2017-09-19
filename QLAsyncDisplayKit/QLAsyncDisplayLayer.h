//
//  QLAsyncDisplayLayer.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QLAsyncDisplayTransaction.h"
#import "QLAsyncDisplayObjectParamters.h"
#import "QLAsyncDisplayImageParamters.h"
#import "QLAsyncDisplayGradientParamters.h"
#import "QLAsyncDisplayTextParamters.h"
#import "NSObject+QLAsyncObjectExtra.h"

#define kUseAsync 1

@interface QLAsyncDisplayLayer : CALayer

@property (nonatomic, strong) QLAsyncDisplayTransaction *displayTransaction;

@property (nonatomic, strong) NSObject *dataObject;

//- (void)displayContents;

//- (void)displaySubContentsWithParameters:(QLAsyncDisplayObjectParamters *)parameters;

- (void)cancelDisplay;

- (void)addSubDisplayObjectParameter:(QLAsyncDisplayObjectParamters *)parameter;

- (void)removeSubDisplayObjectParameter:(QLAsyncDisplayObjectParamters *)parameter;

- (void)removeAllSubDisplayParameters;

- (void)resetData;

@end
