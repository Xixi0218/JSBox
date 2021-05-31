//
//  HLJJSBoxUIManager.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@class HLJJSBoxEngine;
@interface HLJJSBoxUIManager : NSObject
- (void)handleWithEventName:(NSString *)eventName jsValue:(JSValue *)value engine:(HLJJSBoxEngine *)engine;
@end

NS_ASSUME_NONNULL_END
