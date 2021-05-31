//
//  HLJJSBoxEngine.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HLJJSBoxEngineDelegate <NSObject>

- (void)HLJJSBoxPushActionWithUrl:(NSString*)url dependency:(NSArray*)dependency;

@end

@interface HLJJSBoxEngine : NSObject
//context
@property (nonatomic, strong, readonly) JSContext *context;
// 父视图
@property (nonatomic ,weak) UIView *containerView;
// 父视图
@property (nonatomic, weak) UIViewController *currentViewController;
// 代理
@property (nonatomic, weak)  id <HLJJSBoxEngineDelegate> delegate;
// 加载脚本
- (JSValue *)evaluateScript:(NSString *)script;
+ (BOOL)isScriptHaveRender:(NSString *)script;

// 添加js方法到js环境
- (void)addJsfuncWithObject:(id)obj eventName:(NSString *)eventName jsfunc:(JSValue *)jsfunc;
// 调用js方法
- (JSValue *)callJsFuncWithObj:(id)obj eventName:(NSString *)eventName args:(NSArray *)args;
// 添加js数据到js的环境
- (void)addJsValueWithObject:(id)obj name:(NSString *)name jsValue:(JSValue *)value;
// 拿到js的数据
- (JSValue *)getJsValueWithObject:(id)obj name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
