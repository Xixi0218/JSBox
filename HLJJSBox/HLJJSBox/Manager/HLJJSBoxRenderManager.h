//
//  HLJJSBoxRenderManager.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@class HLJJSBoxEngine;
@interface HLJJSBoxRenderManager : NSObject
- (void)renderUIWithJSRender:(JSValue *)jsRender superView:(UIView *)superView idMapDict:(NSMutableDictionary *_Nullable)mapDict engine:(HLJJSBoxEngine *)engine;
@end

NS_ASSUME_NONNULL_END
