//
//  UILabel+HLJJSBox.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HLJJSBox)
@property (nonatomic, assign) NSInteger align;
@property (nonatomic, assign) NSInteger lines;
@property (nonatomic, assign) BOOL autoFontSize;
@end

NS_ASSUME_NONNULL_END
