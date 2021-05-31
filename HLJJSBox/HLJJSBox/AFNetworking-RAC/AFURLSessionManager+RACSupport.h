//
//  AFURLSessionManager+RACSupport.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/26.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "AFURLSessionManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFURLSessionManager (RACSupport)

/// A convenience around -GET:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object and response headers or error.
- (RACSignal *)rac_GET:(NSString *)path parameters:(id _Nullable)parameters;

/// A convenience around -HEAD:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object and response headers or error.
- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id _Nullable)parameters;

/// A convenience around -POST:parameters:success:failure: that returns a cold signal of the
/// result.
- (RACSignal *)rac_POST:(NSString *)path parameters:(id _Nullable)parameters;

/// A convenience around -PUT:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object and response headers or error.
- (RACSignal *)rac_PUT:(NSString *)path parameters:(id _Nullable)parameters;

/// A convenience around -PATCH:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object and response headers or error.
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id _Nullable)parameters;

/// A convenience around -DELETE:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object and response headers or error.
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id _Nullable)parameters;

@end

NS_ASSUME_NONNULL_END
