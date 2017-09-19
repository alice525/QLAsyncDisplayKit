//
//  QLAsyncDisplayObjectParamters.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^async_display_parameter_block_t)(void);

/* 用来绘制图片的数据参数，这是一个基类
 */

@interface QLAsyncDisplayObjectParamters : NSObject

@property (nonatomic, assign) CGRect displayFrame;   //用于绘制的frame，若父视图是gif，此值会被修改，否则其等于frameInSuperLayer

@property (nonatomic, assign) CGRect frameInSuperLayer;  // 相对于父视图的frame，一旦设置，绘制过程不会被更改

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) BOOL opaque;

@property (nonatomic, weak) QLAsyncDisplayObjectParamters *superDisplayParameter;
@property (nonatomic, strong, readonly) NSMutableArray<QLAsyncDisplayObjectParamters *> *subDisplayParameterList;

- (void)displaySelf;

- (async_display_parameter_block_t)getSelfDisplayBlock;

- (void)addSubDisplayParameter:(QLAsyncDisplayObjectParamters *)paramters;

- (void)removeSubDisplayParameter:(QLAsyncDisplayObjectParamters *)paramters;

- (void)cancelDisplay;

@end
