//
//  NSMutableDictionary+HLJJSBoxSafe.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "NSMutableDictionary+HLJJSBoxSafe.h"

@implementation NSMutableDictionary (HLJJSBoxSafe)
- (void)hlj_safeSetObject:(id)object forKey:(NSString *)key {
    if (!key) {
        return;
    }
    object = object ? object : @"";
    [self setObject:object forKey:key];
}
@end
