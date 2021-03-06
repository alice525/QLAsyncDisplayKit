//
//  QLRichLabel.m
//  live4iphone
//
//  Created by alice on 14-9-19.
//  Copyright (c) 2014年 Tencent Inc. All rights reserved.
//

#import "QLHybridTextView.h"

@interface QLHybridTextView()



@end


@implementation QLHybridTextView
@synthesize textHorizonalAlignment = _textHorizonalAlignment;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize text = _text;
@synthesize delegate = _delegate;
@synthesize sizeDelegate = _sizeDelegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setMultipleTouchEnabled:YES];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (QLHybridTextItem *)textItem {
    return nil;
}

- (void)setFrame:(CGRect)frame {
    if (frame.origin.x == self.frame.origin.y &&
        frame.origin.y == self.frame.origin.y &&
        frame.size.width == self.frame.size.width &&
        frame.size.height == self.frame.size.height) {
        return;
    }
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setTextHorizonalAlignment:(RTTextAlignment)textAlignment
{
    _textHorizonalAlignment = textAlignment;
    [self setNeedsDisplay];
}

- (RTTextAlignment)textHorizonalAlignment
{
    return _textHorizonalAlignment;
}

- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    [self setNeedsDisplay];
}

- (RTTextLineBreakMode)lineBreakMode
{
    return _lineBreakMode;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsLayout];
}

- (NSString *)text {
    return _text;
}

- (void)setTextColor:(UIColor*)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (UIColor*)textColor
{
    return _textColor;
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    
    [self setNeedsDisplay];
}

- (UIFont*)font
{
    return _font;
}

- (void)setDelegate:(id<RTLabelDelegate>)delegate {
    _delegate = delegate;
}

- (id<RTLabelDelegate>)delegate {
    return _delegate;
}

- (void)setSizeDelegate:(id<RTLabelSizeDelegate>)sizeDelegate {
    _sizeDelegate = sizeDelegate;
}

- (id<RTLabelSizeDelegate>)sizeDelegate {
    return _sizeDelegate;
}

#pragma mark -
#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (![[self textItem] touchesBegan:touches withEvent:event location:location]) {
        [super touchesBegan:touches withEvent:event];
    } else {
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self dismissBoundRectForTouch];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self dismissBoundRectForTouch];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self textItem] touchesEnded:touches withEvent:event];
    
    [self performSelector:@selector(dismissBoundRectForTouch) withObject:nil afterDelay:0.1];
}

- (void)dismissBoundRectForTouch
{
    [[self textItem]  dismissBoundRectForTouch];
    [self setNeedsDisplay];
}

- (CGSize)optimumSize
{
    _optimumSize = [[self textItem]  optimumSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    return _optimumSize;
}

- (NSUInteger)lineCount
{
    return [[self textItem] lineCount];
}

/* 计算能够显示出来的文本size   alicejhchen (20141107)
 文本无法全部显示出来的原因有：
 1. 指定了最大行数lCount比文本的实际行数少
 2. 控件size比文本所需size小
 lCount为0表示未指定最大行数，希望文本全部显示出来
 */
- (CGSize)linesSize:(NSInteger)lCount constrainedToSize:(CGSize)size
{
    return [[self textItem] linesSize:lCount constrainedToSize:size];
}

+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont*)font maxLineCount:(NSInteger)lineCount lineSpacing:(CGFloat)lineSpacing;
{
    QLHybridTextItem *item = [[QLHybridTextItem alloc] init];
    
    item.text = text;
    item.font = font;
    item.numberOfLines = lineCount;
    item.lineSpacing = lineSpacing;
    item.prefferedMaxLayoutWidth = size.width;
    
    [item translateNormalTextToRichText];
    CGSize resSize = [item optimumSize:size];
    
    return resSize;
}

+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font maxLineCount:(NSInteger)lineCount
{
    return [QLHybridTextView textSizeWithText:text constraintSize:size font:font maxLineCount:lineCount lineSpacing:DEFAULT_LINE_SPACING];
}

+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font
{
    return [QLHybridTextView textSizeWithText:text constraintSize:size font:font maxLineCount:0 lineSpacing:DEFAULT_LINE_SPACING];
}

+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size maxLineCount:(NSInteger)lineCount
{
    return [QLHybridTextView textSizeWithText:text constraintSize:size font:DEFAULT_FONT maxLineCount:lineCount lineSpacing:DEFAULT_LINE_SPACING];
}

+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size
{
    return [QLHybridTextView textSizeWithText:text constraintSize:size font:DEFAULT_FONT maxLineCount:0 lineSpacing:DEFAULT_LINE_SPACING];
}


+ (CGSize)textSizeWithExceedLineCount:(NSUInteger)eCount targetLines:(NSUInteger)tCount text:(NSString *)text constrainedToSize:(CGSize)size  isExceed:(BOOL *)flag font:(UIFont *)font
{
    QLHybridTextView *contentLabel = [[QLHybridTextView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    contentLabel.text = text;
    contentLabel.font = font;
    contentLabel.textHorizonalAlignment = NSTextAlignmentLeft;
    contentLabel.prefferedMaxLayoutWidth = size.width;
    contentLabel.numberOfLines = 0;
    
    [contentLabel layoutSubviews];
    CGSize optimumSize = contentLabel.optimumSize;
    // 如果总行数大于约定的eCount，则按照tCount行的size返回，tencent:jiachunke(20140611)
    if ([contentLabel lineCount] > eCount) {
        *flag = YES;
        optimumSize = [contentLabel linesSize:tCount constrainedToSize:size];
    }
    
    return optimumSize;
}

+ (void)async_textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font maxLineCount:(NSInteger)lineCount lineSpacing:(CGFloat)lineSpacing completeBlock:(async_text_size_caculate_complete_block)completeBlock {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        CGSize textSize = [QLHybridTextView textSizeWithText:text constraintSize:size font:font maxLineCount:lineCount lineSpacing:lineSpacing];
        
        if (completeBlock) {
            completeBlock(textSize);
        }
    });
}

@end
