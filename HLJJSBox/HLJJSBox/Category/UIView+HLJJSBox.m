//
//  UIView+HLJJSBox.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "UIView+HLJJSBox.h"
#import <objc/runtime.h>
#import "HLJJSBoxEngine.h"
#import "HLJJSBoxCommonKey.h"

@implementation UIView (HLJJSBox)

// 背景色
- (void)setBgColor:(UIColor *)bgColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backgroundColor = bgColor;
    });
}

- (UIColor *)bgColor {
    return self.backgroundColor;
}

// 圆角
- (void)setRadius:(CGFloat)radius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (CGFloat)radius {
    return self.layer.cornerRadius;
}

// 父视图
- (UIView *)parentView {
    return self.superview;
}

// 边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

// 边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (BOOL)displayHidden
{
    return self.hidden;
}

- (void)setDisplayHidden:(BOOL)displayHidden
{
    self.hidden = displayHidden;
}

// view ID
- (void)setIdentity:(NSString *)identity
{
    objc_setAssociatedObject(self, @selector(identity), identity, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identity {
    return objc_getAssociatedObject(self, @selector(identity));
}

- (JSValue *)events
{
    return nil;
}

// 事件
- (void)setEvents:(JSValue *)events {
    NSDictionary *ocDict = [events toDictionary];
    for (NSString *key in ocDict.allKeys) {
        JSValue *jsFunc = events[key];
        [self eventsDealingWithEventName:key jsfunc:jsFunc];
    }
}

- (void)setEngine:(HLJJSBoxEngine *)engine
{
    objc_setAssociatedObject(self, @selector(engine), engine, OBJC_ASSOCIATION_ASSIGN);
}

- (HLJJSBoxEngine *)engine
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)eventsDealingWithEventName:(NSString *)eventsName jsfunc:(JSValue *)jsfunc {
    [self.engine addJsfuncWithObject:self eventName:eventsName jsfunc:jsfunc];
    UIGestureRecognizer *ges;
    if ([eventsName isEqualToString:EventTapped]) {
        ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(normalGestureAction:)];
    }
    if ([eventsName isEqualToString:EventLongPressed]) {
        ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(normalGestureAction:)];
    }
    if ([eventsName isEqualToString:EventDoubleTapped]) {
        UITapGestureRecognizer *douTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(normalGestureAction:)];
        douTapGes.numberOfTapsRequired = 2;
        ges = douTapGes;
    }
    if (ges) {
       [self addGestureRecognizer:ges];
    }
}

- (void)normalGestureAction:(UIGestureRecognizer *)ges {
    if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([(UITapGestureRecognizer *)ges numberOfTapsRequired] == 1) {
            [self.engine callJsFuncWithObj:self eventName:EventTapped args:@[ges]];
        }else {
            [self.engine callJsFuncWithObj:self eventName:EventDoubleTapped args:@[ges]];
        }
    }
    if ([ges isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [self.engine callJsFuncWithObj:self eventName:EventLongPressed args:@[ges]];
    }
}

@end
