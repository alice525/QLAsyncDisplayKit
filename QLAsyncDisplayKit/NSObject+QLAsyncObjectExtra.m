//
//  NSObject+QLAsyncObjectExtra.m
//  live4iphone
//
//  Created by alicejhchen on 2017/7/24.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "NSObject+QLAsyncObjectExtra.h"
#import <objc/runtime.h>

#define saved_displayImage_key @"saved_displayImage_key"

@implementation NSObject (QLAsyncObjectExtra)

- (UIImage *)displayImage {
    return objc_getAssociatedObject(self, saved_displayImage_key);
}

- (void)setDisplayImage:(UIImage *)displayImage {
    
    objc_setAssociatedObject(self, saved_displayImage_key, displayImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
