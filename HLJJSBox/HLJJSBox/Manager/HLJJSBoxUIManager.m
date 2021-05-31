//
//  HLJJSBoxUIManager.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxUIManager.h"
#import "HLJJSBoxRenderManager.h"
#import "HLJJSBoxEngine.h"
#import "SVProgressHUD.h"

@interface HLJJSBoxUIManager ()
@property (nonatomic, strong) HLJJSBoxRenderManager *renderManager;
@end

@implementation HLJJSBoxUIManager

- (void)handleWithEventName:(NSString *)eventName jsValue:(JSValue *)value engine:(HLJJSBoxEngine *)engine
{
    if ([eventName isEqualToString:@"render"]) {
        [self.renderManager renderUIWithJSRender:value superView:engine.containerView idMapDict:nil engine:engine];
    }
    
    if ([eventName isEqualToString:@"push"]) {
        if (engine.delegate && [engine.delegate respondsToSelector:@selector(HLJJSBoxPushActionWithUrl:dependency:)]) {
            NSDictionary *dict = [value toDictionary];
            if (dict[@"url"]) {
                [engine.delegate HLJJSBoxPushActionWithUrl:dict[@"url"] dependency:dict[@"dependency"]];
            }
        }
    }
    
    if ([eventName isEqualToString:@"loading"]) {
        id obj = [value toObject];
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showWithStatus:obj];
        }else {
            if ([obj boolValue]) {
                [SVProgressHUD showWithStatus:@"加载中"];
            }else {
                [SVProgressHUD dismiss];
            }
        }
    }
}

- (HLJJSBoxRenderManager *)renderManager
{
    if (!_renderManager) {
        _renderManager = [[HLJJSBoxRenderManager alloc] init];
    }
    return _renderManager;
}

@end
