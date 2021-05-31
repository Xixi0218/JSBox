//
//  HLJQiNiuPathManager.m
//  HLJCoreExtend_Example
//
//  Created by shu_pian on 2019/6/24.
//  Copyright © 2019 九阳. All rights reserved.
//

#import "HLJQiNiuPathManager.h"

@implementation HLJQiNiuPathManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
