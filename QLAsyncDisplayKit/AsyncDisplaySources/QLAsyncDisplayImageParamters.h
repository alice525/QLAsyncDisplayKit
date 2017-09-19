//
//  QLAsyncDisplayImageParamters.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayObjectParamters.h"

@class QLAsyncDisplayLayer;

@interface QLAsyncDisplayImageParamters : QLAsyncDisplayObjectParamters

@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) CGFloat cornorRadius;

@property (nonatomic, assign) BOOL clipToBounds;

@property (nonatomic, assign) BOOL isGifImage;

@property (nonatomic, weak) QLAsyncDisplayLayer *ownedLayer;

- (void)stopLoad;

- (void)handleWhenIsGifImage;

@end
