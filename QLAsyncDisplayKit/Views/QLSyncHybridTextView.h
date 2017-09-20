//
//  QLSyncHybridTextView.h
//  QLAsyncDisplayKit
//
//  Created by alicejhchen on 2017/9/19.
//  Copyright © 2017年 tencentVideo. All rights reserved.
//

#import <QLHybridTextView.h>

@interface QLSyncHybridTextView : QLHybridTextView

- (void)setComponentsAndPlainText:(RTLabelComponentsStructure*)componnetsDS;
- (RTLabelComponentsStructure*)componentsAndPlainText;

@end
