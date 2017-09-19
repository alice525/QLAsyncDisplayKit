//
//  QLAsyncDisplayTextParamters.m
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayTextParamters.h"

@interface QLAsyncDisplayTextParamters ()

@property (nonatomic, assign) BOOL isEmojiText;

@property (atomic, strong) QLHybridTextItem *textItem;

@end

@implementation QLAsyncDisplayTextParamters

- (instancetype)initWithIsEmojiText:(BOOL)isEmojiText {
    if (self = [super init]) {
        _font = [UIFont systemFontOfSize:15];
        
        _textColor = [UIColor blackColor];
        
        _isEmojiText = isEmojiText;
        
        _textHorizonalAlignment = RTTextAlignmentLeft;
        _lineBreakMode = RTTextLineBreakModeWordWrapping;
        
        _numberOfLines = 0;
        _lineSpacing = -1.0;
        _prefferedMaxLayoutWidth = -1;
        
        _delegate = nil;
        _sizeDelegate = nil;

    }
    
    return self;
}

- (instancetype)init {
    NSString *exceptionInfo = [NSString stringWithFormat:@"%@ 必须使用init:初始化",self];
    @throw [NSException exceptionWithName:exceptionInfo reason:nil userInfo:nil];
}

- (void)initTextItem {
    if (!_textItem) {
        _textItem = [[QLHybridTextItem alloc] init];
    }
    
    [_textItem resetParameters];
}

- (void)displaySelf {
    
    if (!_isEmojiText) {
        [self __displayNormalText];
    } else {
        [self __displayEmojiText];
    }
}

- (async_display_parameter_block_t)getSelfDisplayBlock {
    if (!_displayText.length && !_textItem) {
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    async_display_parameter_block_t displayBlock = ^(){
        [weakSelf displaySelf];
    };
    
    return [displayBlock copy];
}

#pragma mark - privates
- (void)__displayNormalText {
    if (!self.displayText.length) {
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
    
    [self.displayText drawInRect:bounds
                  withAttributes:@{NSFontAttributeName: self.font,NSForegroundColorAttributeName:self.textColor}];
    
    [super displaySelf];
    
    CGContextTranslateCTM(context, -self.displayFrame.origin.x, -self.displayFrame.origin.y);
}

- (void)__displayEmojiText {
    
    [self initTextItem];
    self.textItem.text = self.displayText;
    self.textItem.font = self.font;
    self.textItem.textColor = self.textColor;
    self.textItem.lineBreakMode = self.lineBreakMode;
    self.textItem.numberOfLines = self.numberOfLines;
    self.textItem.lineSpacing = self.lineSpacing;
    self.textItem.prefferedMaxLayoutWidth = self.prefferedMaxLayoutWidth;
    self.textItem.textVerticalAlignment = self.textVerticalAlignment;
    self.textItem.textHorizonalAlignment = self.textHorizonalAlignment;
    self.textItem.delegate = self.delegate;
    self.textItem.sizeDelegate = self.sizeDelegate;
    
    [self.textItem translateNormalTextToRichText];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.displayFrame.origin.x, self.displayFrame.origin.y);
    
    CGRect bounds = CGRectMake(0, 0, self.displayFrame.size.width, self.displayFrame.size.height);
    
    if (self.backgroundColor) {
        
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, bounds);
    }

    
    [self.textItem renderInSize:bounds.size];
    
    CGContextTranslateCTM(context, -self.displayFrame.origin.x, -self.displayFrame.origin.y);
}

@end
