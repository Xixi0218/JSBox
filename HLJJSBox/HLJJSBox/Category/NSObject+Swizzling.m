//
//  NSObject+Swizzling.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/24.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(valueForUndefinedKey:);
        SEL swizzSel = @selector(hlj_valueForUndefinedKey:);
        [[self class] exChanageMethodSystemSel:systemSel swizzSel:swizzSel];
        
        SEL systemSetValueSel = @selector(setValue:forKey:);
        SEL swizzSetValueSel = @selector(hlj_setValue:forKey:);
        [[self class] exChanageMethodSystemSel:systemSetValueSel swizzSel:swizzSetValueSel];
        
        SEL systemUndefinedKeySel = @selector(setValue:forUndefinedKey:);
        SEL swizzUndefinedKeySel = @selector(hlj_setValue:forUndefinedKey:);
        [[self class] exChanageMethodSystemSel:systemUndefinedKeySel swizzSel:swizzUndefinedKeySel];
    });
}

+ (void)exChanageMethodSystemSel:(SEL)systemSel swizzSel:(SEL)swizzSel{
    //两个方法的Method
    Method systemMethod = class_getInstanceMethod([self class], systemSel);
    Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
    //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
    BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
    if (isAdd) {
        //如果成功，说明类中不存在这个方法的实现
        //将被交换方法的实现替换到这个并不存在的实现
        class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        //否则，交换两个方法的实现
        method_exchangeImplementations(systemMethod, swizzMethod);
    }
}

- (void)hlj_setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:NSNull.class]) {
        [self hlj_setValue:nil forKey:key];
    } else {
        [self hlj_setValue:value forKey:key];
    }
}

- (void)hlj_setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}

- (id)hlj_valueForUndefinedKey:(NSString *)key
{
    [self hlj_valueForUndefinedKey:key];
    return nil;
}

@end
