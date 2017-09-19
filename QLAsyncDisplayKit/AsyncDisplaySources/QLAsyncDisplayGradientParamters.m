//
//  QLAsyncDisplayGradientParamters.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayGradientParamters.h"

@implementation QLAsyncDisplayGradientParamters

- (void)displaySelf {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.displayFrame.origin.x, self.displayFrame.origin.y);
    
    //创建颜色空间
    CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
    
    //创建渐变
    CGGradientRef gradient = nil;
    
    if (_locations.count) {
        //渐变的开始到结束比例0-－1
        CGFloat locations[]={[_locations[0] floatValue],[_locations[1] floatValue]};
        
        gradient = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef)_colors, locations);
    } else {
        gradient = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef)_colors, NULL);
    }
    
    
    CGRect gRect = CGRectMake(0, 0, CGRectGetWidth(self.displayFrame), CGRectGetHeight(self.displayFrame));
    CGFloat startX = CGRectGetMinX(gRect) + CGRectGetWidth(gRect)*_startPoint.x;
    CGFloat startY = CGRectGetMinY(gRect) + CGRectGetHeight(gRect)*_startPoint.y;
    CGFloat endX = CGRectGetMinX(gRect) + CGRectGetWidth(gRect)*_endPoint.x;
    CGFloat endY = CGRectGetMinY(gRect) + CGRectGetHeight(gRect)*_endPoint.y;
    
    CGContextDrawLinearGradient(context, gradient,CGPointMake(startX,startY),CGPointMake(endX,endY),0);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradient);
    
    [super displaySelf];
    
    CGContextTranslateCTM(context, -self.displayFrame.origin.x, -self.displayFrame.origin.y);
}

- (async_display_parameter_block_t)getSelfDisplayBlock {
    if (!_colors.count) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    async_display_parameter_block_t displayBlock = ^(){
        [weakSelf displaySelf];
    };
    
    return [displayBlock copy];
}

@end
