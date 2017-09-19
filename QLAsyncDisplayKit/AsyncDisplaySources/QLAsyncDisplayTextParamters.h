//
//  QLAsyncDisplayTextParamters.h
//  live4iphone
//
//  Created by alicejhchen on 17/3/31.
//  Copyright © 2017年 Tencent Inc. All rights reserved.
//

#import "QLAsyncDisplayObjectParamters.h"
#import "QLHybridTextItem.h"

typedef void (^async_emoji_text_displayed_block)(QLHybridTextItem *textItem);

@interface QLAsyncDisplayTextParamters : QLAsyncDisplayObjectParamters

@property (nonatomic, strong) NSString *displayText;

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

@property (atomic, strong) QLHybridTextItem *textItem;

- (instancetype)initWithIsEmojiText:(BOOL)isEmojiText;

@end
