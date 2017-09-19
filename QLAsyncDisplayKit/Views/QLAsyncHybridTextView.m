//
//  QLAsyncHybridTextView.m
//  QLAsyncDisplayKit
//
//  Created by alicejhchen on 2017/9/19.
//  Copyright © 2017年 tencentVideo. All rights reserved.
//

#import "QLAsyncHybridTextView.h"
#import "QLAsyncDisplayLayer.h"
#import "QLAsyncDisplayTextParamters.h"

@interface QLAsyncHybridTextView ()

@property (nonatomic, strong) QLAsyncDisplayLayer *asyncDisplayLayer;
@property (nonatomic, strong) QLAsyncDisplayTextParamters *textParameter;

@end

@implementation QLAsyncHybridTextView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.asyncDisplayLayer.frame = self.bounds;
    self.textParameter.frameInSuperLayer = self.bounds;
    
    [self.asyncDisplayLayer setNeedsDisplay];
}

- (QLHybridTextItem *)textItem {
    return self.textParameter.textItem;
}

- (void)setTextHorizonalAlignment:(RTTextAlignment)textAlignment
{
    self.textParameter.textHorizonalAlignment = textAlignment;
    
    [super setTextHorizonalAlignment:textAlignment];
}

- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode
{
    self.textParameter.lineBreakMode = lineBreakMode;
    
    [super setLineBreakMode:lineBreakMode];
}

- (void)setText:(NSString *)text
{
    self.textParameter.displayText = text;
    
    [super setText:text];
}

- (void)setTextColor:(UIColor*)textColor
{
    self.textParameter.textColor = textColor;
}

- (void)setFont:(UIFont*)font
{
    self.textParameter.font = font;
    
    [super setFont:font];
}

- (QLAsyncDisplayLayer *)asyncDisplayLayer {
    if (!_asyncDisplayLayer) {
        _asyncDisplayLayer = [QLAsyncDisplayLayer layer];
        _asyncDisplayLayer.backgroundColor = [UIColor redColor].CGColor;
        
        [self.asyncDisplayLayer addSubDisplayObjectParameter:self.textParameter];
        
        [self.layer addSublayer:self.asyncDisplayLayer];
    }
    
    return _asyncDisplayLayer;
}

- (QLAsyncDisplayTextParamters *)textParameter {
    if (!_textParameter) {
        _textParameter = [[QLAsyncDisplayTextParamters alloc] initWithIsEmojiText:YES];
    }
    
    return _textParameter;
}

@end
