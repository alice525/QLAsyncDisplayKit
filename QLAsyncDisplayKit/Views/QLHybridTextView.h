//
//  QLRichLabel.h
//  live4iphone
//
//  Created by alice on 14-9-19.
//  Copyright (c) 2014年 Tencent Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLHybridTextItem.h"

@interface QLHybridTextView : UIView {
    CGSize _optimumSize;
}

/* text为需要绘制的文本，可包含自定义的表情符号，如[微笑]
 */
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) RTTextLineBreakMode lineBreakMode;
@property (nonatomic, assign)NSInteger numberOfLines;     // 最多可显示的行数，0：显示所有文本 alicejhchen (20140625)
@property (nonatomic, assign)CGFloat lineSpacing;            //行间距, alicejhchen (20140919)
@property (nonatomic, assign) CGFloat prefferedMaxLayoutWidth;  //view的最大宽度，用于计算文本高度，不设置该值计算高度时选取view的宽度    alicejhchen (20141003)
@property (nonatomic, assign) RTTextAlignment textHorizonalAlignment;    //文本x轴方向的对齐
@property (nonatomic, assign)QLTextVerticalAlignment textVerticalAlignment;    //文本y轴方向的对齐方式     alicejhchen (20141023)

@property (nonatomic, assign) id<RTLabelDelegate> delegate;
@property (nonatomic, assign) id<RTLabelSizeDelegate> sizeDelegate;

- (void)setComponentsAndPlainText:(RTLabelComponentsStructure*)componnetsDS;
- (RTLabelComponentsStructure*)componentsAndPlainText;

- (CGSize)optimumSize;

- (NSUInteger)lineCount;
- (CGSize)linesSize:(NSInteger)lCount constrainedToSize:(CGSize)size;

- (QLHybridTextItem *)textItem;

/* 获取文本的高度
 
 text:文本字符串
 size:限制控件的宽高
 font:文本字号
 lineCount:限制文本显示的行数
 lineSpacing:文本行间距
 */
+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font maxLineCount:(NSInteger)lineCount lineSpacing:(CGFloat)lineSpacing;
+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font maxLineCount:(NSInteger)lineCount;
+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size font:(UIFont *)font;
+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size maxLineCount:(NSInteger)lineCount;
+ (CGSize)textSizeWithText:(NSString *)text constraintSize:(CGSize)size;

/*  用于特殊场景：当文本行数超过eCount行时，只显示tCount行，否则显示全部文本
 */
+ (CGSize)textSizeWithExceedLineCount:(NSUInteger)eCount targetLines:(NSUInteger)tCount text:(NSString *)text constrainedToSize:(CGSize)size  isExceed:(BOOL *)flag font:(UIFont *)font;


@end
