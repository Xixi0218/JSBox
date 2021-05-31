//
//  UIView+HLJJSBox.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@class HLJJSBoxEngine;

@protocol UIViewJSExport <JSExport>

@property (nonatomic, weak) JSValue *events;
@property (nonatomic, assign) BOOL displayHidden;
@property (nonatomic, strong, readonly) UIView *parentView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong, readonly) NSArray *subviews;

@end

@interface UIView (HLJJSBox) <UIViewJSExport>

@property (nonatomic, copy) NSString *identity;
@property (nonatomic, assign) BOOL displayHidden;
@property (nonatomic, strong, readonly) UIView *parentView;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, weak) JSValue *events;
@property (nonatomic, weak) HLJJSBoxEngine *engine;
- (void)eventsDealingWithEventName:(NSString *)eventsName jsfunc:(JSValue *)jsfunc;

@end

NS_ASSUME_NONNULL_END
