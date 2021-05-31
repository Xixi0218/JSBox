//
//  HLJJSBoxEngine.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxEngine.h"
#import "HLJJSBoxUIManager.h"
#import "JSValue+judgeNil.h"
#import "UIView+mapView.h"
#import "HLJJSBoxColor.h"
#import "HLJJSBoxFont.h"
#import "HLJJSBoxHttpManager.h"
#import "UIColor+HLJHexColor.h"

#define HLJWeakSelf __weak __typeof(self)weakSelf = self;
#define HLJStrongSelf __strong __typeof(weakSelf)self = weakSelf;

@interface HLJJSBoxEngine ()

@property (nonatomic, strong, readwrite) JSContext *context;
@property (nonatomic, weak) UIView *idMapDictHostView;
@property (nonatomic, strong) HLJJSBoxHttpManager *httpManager;
@property (nonatomic, strong) HLJJSBoxUIManager *uiManager;
@end

@implementation HLJJSBoxEngine

- (void)startEngine
{
    if (self.context) {
        return;
    }
    HLJWeakSelf
    JSContext *context = [[JSContext alloc] init];
    self.context = context;
    context[@"oc_log"] = ^(JSValue *data) {
        id dataObj = [data toObject];
        if ([dataObj isKindOfClass:[NSNumber class]]) {
            NSLog(@"oc_log === %f",[dataObj floatValue]);
        } else {
            NSLog(@"oc_log === %@",dataObj);
        }
    };
    
    context[@"vc_config"] = ^(NSString *eventName, JSValue *data) {
        HLJStrongSelf
        NSDictionary*config = [data toDictionary];
        NSDictionary *props = config[@"props"];
        self.currentViewController.navigationItem.title = props[@"title"];
        self.currentViewController.edgesForExtendedLayout = [props[@"rectEdge"] integerValue];
    };
    
    context[@"oc_ui"] = ^(NSString *eventName, JSValue *data) {
        HLJStrongSelf
        [self.uiManager handleWithEventName:eventName jsValue:data engine:self];
    };
    
    // 根据id取view
    context[@"oc_id_map_view"] = ^id(JSValue *identity) {
        HLJStrongSelf
        if (!identity.isNil) {
            return self.idMapDictHostView.mapViewDict[[identity toString]];
        }
        return nil;
    };
    // 颜色
    context[@"oc_color"] = ^id(JSValue *colorStr,JSValue *alpha) {
        return [UIColor colorWithHexString:[colorStr toString] alpha:[alpha toDouble]];
    };
    // 字体
    context[@"oc_font"] = ^id(JSValue *v1,JSValue *v2) {
        return [HLJJSBoxFont fontWithValue1:v1 value2:v2];
    };
    // 请求
    context[@"oc_request"] = ^(JSValue *request) {
        HLJStrongSelf
        [self.httpManager callRequestWithEngine:request];
    };
    
    //加载js文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HLJJSBox" ofType:@"js"];
    [self evaluateScriptWithPath:path];
}

- (JSValue *)evaluateScriptWithPath:(NSString *)path {
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [self evaluateScript:script];
}

- (JSValue *)evaluateScript:(NSString *)script
{
    [self startEngine];
    return [_context evaluateScript:script];
}

+ (BOOL)isScriptHaveRender:(NSString *)script {
    return [script containsString:@"$ui.render"];
}

- (void)addJsfuncWithObject:(id)obj eventName:(NSString *)eventName jsfunc:(JSValue *)jsfunc{
    NSString *funcName = [self _jsPropertyNameForObj:obj name:eventName];
    [self.context[@"addJsProperty"] callWithArguments:@[funcName,jsfunc]];
}

- (JSValue *)callJsFuncWithObj:(id)obj eventName:(NSString *)eventName args:(NSArray *)args {
    NSString *funcName = [self _jsPropertyNameForObj:obj name:eventName];
    return [self.context[funcName] callWithArguments:args];
}

- (void)addJsValueWithObject:(id)obj name:(NSString *)name jsValue:(JSValue *)value {
    NSString *propertyName = [self _jsPropertyNameForObj:obj name:name];
    [self.context[@"addJsProperty"] callWithArguments:@[propertyName,value]];
}

- (JSValue *)getJsValueWithObject:(id)obj name:(NSString *)name {
    NSString *propertyName = [self _jsPropertyNameForObj:obj name:name];
    return self.context[propertyName];
}

#pragma mark - pravite method
- (NSString *)_jsPropertyNameForObj:(id)obj name:(NSString *)name {
    NSString *idress = [NSString stringWithFormat:@"%p",obj];
    return [NSString stringWithFormat:@"%@_%@",idress,name];
}


#pragma mark - set
- (void)setContainerView:(UIView *)containerView
{
    _containerView = containerView;
    self.idMapDictHostView = containerView;
}

#pragma mark - get
- (HLJJSBoxHttpManager *)httpManager {
    if (_httpManager == nil) {
        _httpManager = [[HLJJSBoxHttpManager alloc]init];
    }
    return _httpManager;
}

- (HLJJSBoxUIManager *)uiManager
{
    if (!_uiManager) {
        _uiManager = [[HLJJSBoxUIManager alloc] init];
    }
    return _uiManager;
}

@end
