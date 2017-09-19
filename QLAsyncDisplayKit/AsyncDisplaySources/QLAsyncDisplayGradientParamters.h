//
//  QLAsyncDisplayGradientParamters.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayObjectParamters.h"

@interface QLAsyncDisplayGradientParamters : QLAsyncDisplayObjectParamters

// 参数的含义参考 CAGradientLayer

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */
@property (nonatomic, copy) NSArray *colors;

@property (nonatomic, copy) NSArray <NSNumber *> *locations;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end
