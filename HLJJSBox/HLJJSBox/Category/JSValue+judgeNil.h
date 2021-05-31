//
//  JSValue+judgeNil.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSValue (judgeNil)

- (BOOL)isNil;

@end

NS_ASSUME_NONNULL_END
