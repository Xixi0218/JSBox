//
//  JSValue+judgeNil.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "JSValue+judgeNil.h"

@implementation JSValue (judgeNil)

- (BOOL)isNil {
    return self.isNull || self.isUndefined;
}

@end
