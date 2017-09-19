//
//  ViewController.m
//  QLAsyncDisplayUseDemo
//
//  Created by alicejhchen on 2017/9/14.
//  Copyright © 2017年 tencentVideo. All rights reserved.
//

#import "ViewController.h"
#import "QLHybridTextView.h"
#import "QLAsyncDisplayLayer.h"

@interface ViewController ()

@property (nonatomic, strong) QLHybridTextView *textView;

@property (nonatomic, strong) QLAsyncDisplayLayer *displayImageLayer;
@property (nonatomic, strong) QLAsyncDisplayTextParamters *textParameter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.textView = [[QLHybridTextView alloc] initWithFrame:CGRectZero];
//    self.textView.isAsyncDisplay = YES;
//    self.textView.text = @"测试下富文本[微笑]或者emoji😭";
    _displayImageLayer = [QLAsyncDisplayLayer layer];
    _displayImageLayer.backgroundColor = [UIColor redColor].CGColor;
    
    _textParameter = [[QLAsyncDisplayTextParamters alloc] initWithIsEmojiText:YES];
    [_displayImageLayer addSubDisplayObjectParameter:_textParameter];
    
    [self.view.layer addSublayer:_displayImageLayer];

    [self.view addSubview:self.textView];
    
    [self initializeDisplayLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.textView.frame = CGRectMake(100, 100, 300, 20);
    _displayImageLayer.frame = CGRectMake(100, 200, 300, 20);
    
    _textParameter.frameInSuperLayer = CGRectMake(0, 0, _displayImageLayer.frame.size.width, _displayImageLayer.frame.size.height);
    
    [_displayImageLayer setNeedsDisplay];
}

- (void)initializeDisplayLayer {
    _displayImageLayer.opaque = YES;
    _displayImageLayer.contents = nil;
    [_displayImageLayer cancelDisplay];
    
    _textParameter.displayText = @"来[发呆]";
    _textParameter.font = [UIFont systemFontOfSize:15];
    _textParameter.textColor = [UIColor blackColor];
    _textParameter.opaque = NO;
    
    _displayImageLayer.dataObject = _textParameter.displayText;
    
//    _textParameter.textItem = [[QLHybridTextItem alloc] initWithString:_textParameter.displayText];
//    _textParameter.textItem.font = [UIFont systemFontOfSize:15];
//    _textParameter.textItem.textColor = [UIColor blackColor];
}

@end
