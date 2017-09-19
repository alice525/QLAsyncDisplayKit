//
//  ViewController.m
//  QLAsyncDisplayUseDemo
//
//  Created by alicejhchen on 2017/9/14.
//  Copyright © 2017年 tencentVideo. All rights reserved.
//

#import "ViewController.h"
#import "QLAsyncHybridTextView.h"
#import "QLAsyncDisplayLayer.h"

@interface ViewController () <RTLabelDelegate>

@property (nonatomic, strong) QLAsyncHybridTextView *textView;

@property (nonatomic, strong) QLAsyncDisplayLayer *displayImageLayer;
@property (nonatomic, strong) QLAsyncDisplayTextParamters *textParameter;

@property (nonatomic, assign) CGSize textSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textView = [[QLAsyncHybridTextView alloc] initWithFrame:CGRectZero];

    self.textView.text = @"测试下富文本[微笑]或者emoji😭链接呢http://url.cn/2D8F2e";
    self.textView.delegate = self;

    [self.view addSubview:self.textView];
    
    __weak typeof(self) weakSelf = self;
    [QLHybridTextView async_textSizeWithText:self.textView.text constraintSize:CGSizeMake(300, 1000) font:[UIFont systemFontOfSize:15] maxLineCount:0 lineSpacing:0 completeBlock:^(CGSize textSize) {
        weakSelf.textSize = textSize;
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (CGSizeEqualToSize(self.textSize, CGSizeZero)) {
        self.textSize = [QLHybridTextView textSizeWithText:self.textView.text constraintSize:CGSizeMake(300, 1000) font:[UIFont systemFontOfSize:15] maxLineCount:0 lineSpacing:0];
    }
    
    self.textView.frame = CGRectMake(20, 50, self.textSize.width, self.textSize.height);

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
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString*)url {
    if (url.length) {
        NSLog(@"jump url:%@",url);
    }
}

@end
