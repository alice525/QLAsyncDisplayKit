//
//  QLSyncHybridTextView.m
//  QLAsyncDisplayKit
//
//  Created by alicejhchen on 2017/9/19.
//  Copyright © 2017年 tencentVideo. All rights reserved.
//

#import "QLSyncHybridTextView.h"

@interface QLSyncHybridTextView ()

@property (nonatomic, strong) QLHybridTextItem *textItem;

@end

@implementation QLSyncHybridTextView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _textItem = [[QLHybridTextItem alloc] init];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_textItem translateNormalTextToRichText];
}

- (QLHybridTextItem *)textItem {
    return _textItem;
}

- (void)setTextHorizonalAlignment:(RTTextAlignment)textAlignment
{
    _textItem.textHorizonalAlignment = textAlignment;
    
    [super setTextHorizonalAlignment:textAlignment];
}

- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode
{
    _textItem.lineBreakMode = lineBreakMode;
    
    [super setLineBreakMode:lineBreakMode];
}

- (void)setText:(NSString *)text
{
    _textItem.text = text;
    
    [super setText:text];
}

- (void)setTextColor:(UIColor*)textColor
{
    _textItem.textColor = textColor;
}

- (void)setFont:(UIFont*)font
{
    _textItem.font = font;
    
    [super setFont:font];
}

- (void)setDelegate:(id<RTLabelDelegate>)delegate {
    _textItem.delegate = delegate;
    
    [super setDelegate:delegate];
}

- (void)setSizeDelegate:(id<RTLabelSizeDelegate>)sizeDelegate {
    _textItem.sizeDelegate = sizeDelegate;
    
    [super setSizeDelegate:sizeDelegate];
}

- (void)setComponentsAndPlainText:(RTLabelComponentsStructure*)componnetsDS {
    _textItem.componentsAndPlainText = componnetsDS;

    [self setNeedsDisplay];
}

- (RTLabelComponentsStructure*)componentsAndPlainText {
    return _textItem.componentsAndPlainText ;
}

#pragma mark -
#pragma excute render
- (void)drawRect:(CGRect)rect
{
    [_textItem renderInSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

@end
