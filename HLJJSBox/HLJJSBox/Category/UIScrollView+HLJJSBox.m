//
//  UIScrollView+HLJJSBox.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//
#import "UIScrollView+HLJJSBox.h"

@implementation UIScrollView (HLJJSBox)

- (BOOL)showVerticalIndicator
{
    return self.showsVerticalScrollIndicator;
}

- (void)setShowVerticalIndicator:(BOOL)showVerticalIndicator
{
    self.showsVerticalScrollIndicator = showVerticalIndicator;
}

- (BOOL)showHorizontalIndicator
{
    return self.showsHorizontalScrollIndicator;
}

- (void)setShowHorizontalIndicator:(BOOL)showHorizontalIndicator
{
    self.showsHorizontalScrollIndicator = showHorizontalIndicator;
}

@end
