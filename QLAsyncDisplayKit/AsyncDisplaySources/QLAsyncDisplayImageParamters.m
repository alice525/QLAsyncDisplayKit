//
//  QLAsyncDisplayImageParamters.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayImageParamters.h"
//#import "QLImageLoadManager.h"
#import "QLAsyncDisplayLayer.h"
//#import "QLGifDecodeProtocol.h"

#define ASDISPLAY_INLINE static inline

ASDISPLAY_INLINE BOOL ASImageAlphaInfoIsOpaque(CGImageAlphaInfo info) {
    switch (info) {
        case kCGImageAlphaNone:
        case kCGImageAlphaNoneSkipLast:
        case kCGImageAlphaNoneSkipFirst:
            return YES;
        default:
            return NO;
    }
}

@interface QLAsyncDisplayImageParamters () /*<QLImageLoadDelegate, QLGifDecodeProtocol, QLGifDecodeImageViewProtocol>*/

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign) BOOL isLoading; //正在加载
@property (nonatomic, assign) BOOL isLoaded; //加载完毕

@property (nonatomic, strong) CALayer *animatingLayer;  //gif图layer

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSArray *animationImages;
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation QLAsyncDisplayImageParamters



- (void)setImageUrl:(NSString *)imageUrl {
    
    if (![imageUrl isEqualToString:imageUrl]) {
        [self stopLoad];
        
        [self __stopAnimating];
    }
    
    _imageUrl = imageUrl;
    
    if (!imageUrl.length) {
        self.displayImage = nil;
    } else {
        [self __reloadImage];
    }
}

- (void)stopLoad {
   // [[QLImageLoadManager sharedInstance] cancelImageLoadWithDelegate:self];
}

- (void) cancelDisplay {
    [self stopLoad];
    
    [super cancelDisplay];
}

#pragma mark - lifeCycle

- (void)dealloc {
    [self stopLoad];
}

- (void)displaySelf {
    
    if (!self.displayImage) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.displayFrame.origin.x, self.displayFrame.origin.y);
    
    CGRect bounds = CGRectMake(0, 0, self.displayFrame.size.width, self.displayFrame.size.height);
    
    if (self.backgroundColor) {
        
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, bounds);
    }
    
    if (self.clipToBounds) {
        if (self.cornorRadius > 0) {
            [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornorRadius] addClip];
        } else {
            CGContextClipToRect(context, bounds);
        }
    }
    
    if (self.displayImage) {
        BOOL opaque = ASImageAlphaInfoIsOpaque(CGImageGetAlphaInfo(self.displayImage.CGImage));
        
        if (opaque) {
            opaque = self.opaque;
        }
        
        CGBlendMode blendMode = opaque ? kCGBlendModeCopy : kCGBlendModeNormal;
        [self.displayImage drawInRect:bounds blendMode:blendMode alpha:1];
    }
    
    if (self.isGifImage) {
        [self handleWhenIsGifImage];
        
    } else {
        [super displaySelf];
    }
    
    CGContextTranslateCTM(context, -self.displayFrame.origin.x, -self.displayFrame.origin.y);
}

- (async_display_parameter_block_t)getSelfDisplayBlock {
    if (!self.displayImage) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    async_display_parameter_block_t displayBlock = ^(){
        [weakSelf displaySelf];
    };
    
    return [displayBlock copy];
}

- (void)handleWhenIsGifImage {
    if (!_animatingLayer) {
        _animatingLayer = [CALayer layer];
    }
    
    _animatingLayer.frame = self.displayFrame;
    [self.ownedLayer addSublayer:_animatingLayer];
    
    [self __startAnimating];
    
    [self __displaySubParameter];
    
}

#pragma mark - privates


- (void)__reloadImage {
    if (!_imageUrl.length) {
        return;
    }
    
//    UIImage* image = [[QLImageLoadManager sharedInstance] loadImageWithURL:_imageUrl type:QLImageType_General delegate:self saveFilePath:self.filePath];
//    if (image) {
//        self.displayImage = image;
//        [self __didLoadImageFromCache:image forURL:_imageUrl];
//    }

}

- (NSString *)__imageFilePath
{
    NSString *filePath = nil;
    if ([self.imageUrl hasPrefix:@"/"] || [self.imageUrl hasPrefix:@"file"]) {
        filePath = self.imageUrl;
    } else {
        if (self.filePath.length)
        {
            filePath = self.filePath;
        }
        else
        {
           // filePath = [FileHelper getImageCachePath];
        }
        
       // filePath = [filePath stringByAppendingPathComponent:[self.imageUrl md5Hash]];
    }
    
    return filePath;
}

- (void)__didLoadImageFromCache:(UIImage *)image forURL:(NSString *)imageURL
{
    [self.ownedLayer setNeedsDisplay];
}

- (void)__startAnimating {
    
    if (_animatingLayer.superlayer) {
        
        NSMutableArray *cgImages = [NSMutableArray array];
        
        for (UIImage *img in _animationImages) {
            if (img.CGImage) {
                [cgImages addObject:(__bridge id)img.CGImage];
            }
        }
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = _animationDuration;
        animation.values = cgImages;
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        
        [_animatingLayer addAnimation:animation forKey:@"gifAnimation"];
        
        self.isAnimating = YES;
    }
}

- (void)__stopAnimating {
    
    if (_isAnimating) {
        [_animatingLayer removeAnimationForKey:@"gifAnimation"];
        
        self.isAnimating = NO;
        
        [_animatingLayer removeFromSuperlayer];
    }
}

- (void)__displaySubParameter {
    [self.subDisplayParameterList enumerateObjectsUsingBlock:^(QLAsyncDisplayObjectParamters * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLAsyncDisplayLayer *dLayer = [QLAsyncDisplayLayer layer];
        dLayer.opaque = obj.opaque;
        dLayer.frame = obj.frameInSuperLayer;
        obj.displayFrame = CGRectMake(0, 0, CGRectGetWidth(dLayer.frame), CGRectGetHeight(dLayer.frame));
        
        [dLayer addSubDisplayObjectParameter:obj];
        
        if ([obj isKindOfClass:[QLAsyncDisplayImageParamters class]]) {
            ((QLAsyncDisplayImageParamters *)obj).ownedLayer = dLayer;
        }
        
        obj.superDisplayParameter = nil;
        
        [self.ownedLayer addSublayer:dLayer];
        
        [dLayer setNeedsDisplay];
        
        //[dLayer displayContents];
    }];
}

#pragma mark - QLImageLoadDelegate
- (void)didLoadImage:(UIImage*)image forURL:(NSString*)imageURL
{
    //QLLogD(@"didLoadImage,url=%@",imageURL);
    
    if (image) {
        self.displayImage = image;
        
        //[self.ownedLayer displaySubContentsWithParameters:self];
        [self.ownedLayer setNeedsDisplay];
    }
}

#pragma mark - QLGifDecodeImageViewProtocol
// 4.9.5 added by jiachunke
- (NSURL *)imageUrlForGifDecode
{
    NSString *filePath = [self __imageFilePath];
    return [NSURL fileURLWithPath:filePath];
}

#pragma mark - QLGifDecodeProtocol
- (void)doGifFinishDecoded:(NSArray *)images animationDuration:(CGFloat)animationDuration {
    
    if (images.count > 1) {
        
        self.animationImages = images;
        self.animationDuration = animationDuration;
    }
}

- (void)doFirstFrameImageFinished:(UIImage *)image {
    
    self.isGifImage = YES;

    self.displayImage = image;
    self.ownedLayer.contents = nil;
    [self.ownedLayer setNeedsDisplay];
    //[self.ownedLayer displaySubContentsWithParameters:self];
}


@end
