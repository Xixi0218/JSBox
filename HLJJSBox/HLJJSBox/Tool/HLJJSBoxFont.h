//
//  HLJJSBoxFont.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJJSBoxFont : NSObject
+ (UIFont *)fontWithValue1:(JSValue *)value1 value2:(JSValue *)value2;
@end

NS_ASSUME_NONNULL_END
