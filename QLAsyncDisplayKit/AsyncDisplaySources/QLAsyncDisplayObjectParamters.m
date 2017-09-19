//
//  QLAsyncDisplayObjectParamters.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayObjectParamters.h"

@interface QLAsyncDisplayObjectParamters ()

@property (nonatomic, strong) NSMutableArray<QLAsyncDisplayObjectParamters *> *subDisplayParameterList;

@end

@implementation QLAsyncDisplayObjectParamters

- (instancetype)init {
    if (self = [super init]) {
        self.opaque = YES;
        
        self.subDisplayParameterList = [NSMutableArray array];
    }
    
    return self;
}

- (void)displaySelf {
    NSArray *parameterList = nil;
    @synchronized (_subDisplayParameterList) {
        parameterList = [_subDisplayParameterList copy];
    }
    
    [parameterList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj displaySelf];
    }];
}

- (async_display_parameter_block_t)getSelfDisplayBlock {
    return nil;
}

- (void)addSubDisplayParameter:(QLAsyncDisplayObjectParamters *)paramters {
    if (paramters) {
        paramters.superDisplayParameter = self;
        
        @synchronized (_subDisplayParameterList) {
            [self.subDisplayParameterList addObject:paramters];
        }
    }
}

- (void)removeSubDisplayParameter:(QLAsyncDisplayObjectParamters *)paramters {
    if (paramters) {
        paramters.superDisplayParameter = nil;
        
        @synchronized (_subDisplayParameterList) {
            [self.subDisplayParameterList removeObject:paramters];
        }
    }
}

- (void)cancelDisplay {
    NSArray *parameterList = nil;
    @synchronized (_subDisplayParameterList) {
        parameterList = [_subDisplayParameterList copy];
    }
    
    [parameterList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancelDisplay];
    }];
}

- (void)setFrameInSuperLayer:(CGRect)frameInSuperLayer {
    _frameInSuperLayer = frameInSuperLayer;
    _displayFrame = frameInSuperLayer;
}

@end
