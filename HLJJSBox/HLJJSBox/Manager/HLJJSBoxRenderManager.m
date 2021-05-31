//
//  HLJJSBoxRenderManager.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxRenderManager.h"
#import "UIView+mapView.h"
#import "UIView+HLJJSBox.h"
#import "HLJJSBoxUIParseManager.h"
#import "Masonry.h"
#import "UIView+Yoga.h"
#import "YGLayout.h"
#import "FlexNode.h"
#import <objc/runtime.h>
#import "HLJJSBoxEngine.h"

@interface HLJJSBoxRenderManager ()
@property (nonatomic, strong) HLJJSBoxUIParseManager *uiParseManager;
@end

@implementation HLJJSBoxRenderManager

- (void)renderUIWithJSRender:(JSValue *)jsRender superView:(UIView *)superView idMapDict:(NSMutableDictionary *_Nullable)mapDict engine:(HLJJSBoxEngine *)engine
{
    NSAssert(jsRender != nil, @"不能为空");
    JSValue *jsViews = jsRender[@"views"];
    NSArray *views = [jsViews toArray];
    if (views) {
        NSInteger count = views.count;
        mapDict = mapDict ? mapDict : superView.mapViewDict;
        [self _renderUIWithJsRender:jsViews superView:superView viewCount:count mapViewDict:mapDict engine:engine];
    }
}

- (void)_renderUIWithJsRender:(JSValue*)jsRender superView:(UIView*)superView viewCount:(NSInteger)viewCount mapViewDict:(NSMutableDictionary*)viewMapDict engine:(HLJJSBoxEngine *)engine {
    for (int i = 0; i < viewCount; i++) {
        JSValue *viewJSValue = jsRender[i];
        // 布局
        UIView *view = [self.uiParseManager parsingViewForJSValue:viewJSValue superView:superView idMapViewDict:viewMapDict engine:engine];
        JSValue *layoutJSFunc = viewJSValue[@"layout"];
        [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            NSDictionary *layoutDictionary =  [layoutJSFunc toDictionary];
            [layoutDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                    FlexApplyLayoutParam(layout, key, ((NSNumber*)obj).stringValue);
                } else {
                    FlexApplyLayoutParam(layout, key, obj);
                }
            }];
        }];
        
        //为了查找视图下面有没有子视图
        JSValue *jsViews = viewJSValue[@"views"];
        NSArray *views = [jsViews toArray];
        if (views) {
            [self renderUIWithJSRender:viewJSValue superView:view idMapDict:viewMapDict engine:engine];
        }
        [self renderUIWithJSRender:jsRender superView:superView idMapDict:viewMapDict engine:engine];
    }
    //刷新页面
    superView.yoga.isEnabled = YES;
    [superView.yoga applyLayoutPreservingOrigin:YES];
}

- (HLJJSBoxUIParseManager *)uiParseManager
{
    if (!_uiParseManager) {
        _uiParseManager = [[HLJJSBoxUIParseManager alloc] init];
    }
    return _uiParseManager;
}

@end
