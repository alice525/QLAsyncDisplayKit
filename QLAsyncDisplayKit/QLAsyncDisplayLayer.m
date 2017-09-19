//
//  QLAsyncDisplayLayer.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayLayer.h"

@interface  QLAsyncDisplayLayer ()

@property (nonatomic, strong) NSMutableArray<QLAsyncDisplayObjectParamters *> *subDisplayObjectParameterList;

@end

@implementation QLAsyncDisplayLayer

- (void)cancelDisplay {
    
    [_subDisplayObjectParameterList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancelDisplay];
    }];
}

- (void)setNeedsDisplay {
    //[self resetData];
    
    [super setNeedsDisplay];
}

- (void)display {

    NSArray <QLAsyncDisplayObjectParamters *> *parametersList = nil;
    @synchronized (_subDisplayObjectParameterList) {
        parametersList = [_subDisplayObjectParameterList copy];
    }
    
    if (_dataObject && _dataObject.displayImage) {
        
        self.contents = (__bridge id)_dataObject.displayImage.CGImage;
        self.contentsScale = [UIScreen mainScreen].scale;
        
        [parametersList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QLAsyncDisplayImageParamters class]]) {
                QLAsyncDisplayImageParamters *imgParameter = (QLAsyncDisplayImageParamters *)obj;
                
                if (imgParameter.isGifImage) {
                    [imgParameter handleWhenIsGifImage];
                }
                
            }
        }];
        
        
    } else if (parametersList.count) {
        
        NSArray<CALayer *> *subLayers = nil;
        @synchronized (self.sublayers) {
            subLayers = [self.sublayers copy];
        }
        
        [subLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
        
       __block NSMutableArray<async_display_parameter_block_t> *displayBlockList = [NSMutableArray array];
        
        [parametersList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (displayBlockList) {
                async_display_parameter_block_t displayBlock = [obj getSelfDisplayBlock];
                
                if (displayBlock) {
                    [displayBlockList addObject:displayBlock];
                }
            }
        }];
        
        if (displayBlockList.count) {
            
            __weak typeof(self) weakSelf = self;
            async_transaction_display_block_t transactionDisplayBlock = ^() {
                UIGraphicsBeginImageContextWithOptions(weakSelf.frame.size, NO, [UIScreen mainScreen].scale);
                
                [displayBlockList enumerateObjectsUsingBlock:^(async_display_parameter_block_t  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj();
                }];
                
                UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                return resultImage;
                
                
            };
        
            async_transaction_complete_block_t transactionCompleteBlock = ^(UIImage *image){
                __strong QLAsyncDisplayLayer *strongSelf = weakSelf;
                strongSelf.contents = (__bridge id _Nullable)(image.CGImage);
                
                strongSelf.dataObject.displayImage = image;
            };
            
            if (self.displayTransaction) {
                [self.displayTransaction cancelDisplay];
            }
            
            self.displayTransaction = [QLAsyncDisplayTransaction transactionWithDisplayBlock:transactionDisplayBlock completeBlock:transactionCompleteBlock];
        }
        
    }

}

- (void)setFrame:(CGRect)frame {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [super setFrame:frame];
    
    [CATransaction commit];
}

- (void)setContents:(id)contents {
    
    [super setContents:contents];
}

/* imageView所在页面不可见时，会调用该方法，底层的该方法又会调用stopAnimating导致gif图动画暂停，
 页面再次可见无法启动动画了，所以在此强制重新启动动画，alicejhchen (2016-06-08)
 */
- (void)removeAnimationForKey:(NSString *)key {
    [super removeAnimationForKey:key];
}

- (void)setDataObject:(NSObject *)dataObject {
    if (_dataObject != dataObject) {
        [self cancelDisplay];
    }
    
    _dataObject = dataObject;
}

- (void)addSubDisplayObjectParameter:(QLAsyncDisplayObjectParamters *)parameter {
    
    @synchronized (_subDisplayObjectParameterList) {
        if (!_subDisplayObjectParameterList) {
            _subDisplayObjectParameterList = [NSMutableArray array];
        }
        
        [_subDisplayObjectParameterList addObject:parameter];
    }
}

- (void)removeSubDisplayObjectParameter:(QLAsyncDisplayObjectParamters *)parameter {
    
    @synchronized (_subDisplayObjectParameterList) {
        if (!_subDisplayObjectParameterList) {
            return;
        }
        
        [_subDisplayObjectParameterList removeObject:parameter];
    }
}

- (void)removeAllSubDisplayParameters {
    @synchronized (_subDisplayObjectParameterList) {
        [_subDisplayObjectParameterList removeAllObjects];
    }
}

- (void)resetData {
    self.dataObject.displayImage = nil;
}

@end
