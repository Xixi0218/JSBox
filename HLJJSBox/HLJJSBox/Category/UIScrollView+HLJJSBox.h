//
//  UIScrollView+HLJJSBox.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol HLJJSBoxUIScrollViewExport <JSExport>
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL alwaysBounceVertical;
@property (nonatomic, assign) BOOL alwaysBounceHorizontal;
@property (nonatomic, assign) BOOL showHorizontalIndicator;
@property (nonatomic, assign) BOOL showVerticalIndicator;
@property (nonatomic, assign) BOOL tracking;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) BOOL decelerating;
@property (nonatomic, assign) NSInteger keyboardDismissMode;
@end

@interface UIScrollView (HLJJSBox) <HLJJSBoxUIScrollViewExport>
@property (nonatomic, assign) BOOL showHorizontalIndicator;
@property (nonatomic, assign) BOOL showVerticalIndicator;
@end
