//
//  HLJJSBoxUIParseManager.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxUIParseManager.h"
#import "JSValue+judgeNil.h"
#import "UIView+mapView.h"
#import "UIView+HLJJSBox.h"
#import "HLJJSBoxEngine.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIList.h"
#import "UICollection.h"

@implementation HLJJSBoxUIParseManager

- (UIView *)parsingViewForJSValue:(JSValue *)jsValue superView:(UIView *)superView idMapViewDict:(NSMutableDictionary *)mapDict engine:(HLJJSBoxEngine *)engine
{
    // 转换类型
    NSDictionary *viewDict = [jsValue toDictionary];
    // view 类型
    NSString *viewType = viewDict[@"type"];
    //解析出对应的ui class
    NSString *viewClassName = [self classNameForIdentity:viewType];
    // ui参数
    NSDictionary *props = viewDict[@"props"];
    // 根据类和参数生成view
    UIView *view = [(UIView*)[NSClassFromString(viewClassName) alloc] init];
    [superView addSubview:view];
    // 特殊情况的处理
    // uibutton
    if ([viewClassName isEqualToString:NSStringFromClass([UIButton class])]) {
        JSValue *btnType = jsValue[@"props"][@"type"];
        if (!btnType.isNil) {
            view = [UIButton buttonWithType:[[btnType toObject] integerValue]];
        }
    }
    
    view.engine = engine;
    
    // id->view 存一下
    if ([props.allKeys containsObject:@"identity"]) {
        NSString *key = props[@"identity"];
        mapDict[key] = view;
    } else {
        mapDict[viewType] = view;
    }
    for (NSString *key in props.allKeys) {
        id obj = [props objectForKey:key];
        if ([[self _otherClassMapping] containsObject:key]) {
            obj = [self parsingOtherWithClassName:key data:obj];
        }
        [view setValue:obj forKey:key];
    }
    //手势事件
    [view setValue:jsValue[@"events"] forKey:@"events"];
    
    // 因为属性字典是无序的,所以可能导致设置刷新有误
    if ([view isKindOfClass:[UIList class]]) {
        [(UIList*)view setup];
    } else if ([view isKindOfClass:[UICollection class]]) {
        [(UICollection*)view setup];
    }
    return view;
}

//主要解析props中类似于flowlayout这样的属性
- (id)parsingOtherWithClassName:(NSString*)className data:(id)data
{
    if ([className isEqualToString:@"flowLayout"]) {
        if (![data isKindOfClass:NSDictionary.class]) {
            NSAssert([data isKindOfClass:NSDictionary.class], @"必须是NSDictionary类型");
        }
        NSDictionary *flowLayoutDic = (NSDictionary*)data;
        NSString *otherClassName = flowLayoutDic[@"type"];
        NSDictionary*otherClassProps = flowLayoutDic[@"props"];
        id otherClassObj = [[NSClassFromString(otherClassName) alloc] init];
        for (NSString *otherClassPropKey in otherClassProps.allKeys) {
            id otherPropObj = [otherClassProps objectForKey:otherClassPropKey];
            if ([[self _specialProp] containsObject:otherClassPropKey]) {
                if ([otherClassPropKey isEqualToString:@"sectionInset"]) {
                    otherPropObj = [self dealSectionInset:otherPropObj];
                } else if ([otherClassPropKey isEqualToString:@"itemSize"]) {
                    otherPropObj = [self dealItemSize:otherPropObj];
                }
            }
            [otherClassObj setValue:otherPropObj forKey:otherClassPropKey];
        }
        return otherClassObj;
    } else if ([className isEqualToString:@"itemSize"]) {
        return [self dealItemSize:data];
    }
    return nil;
}

- (NSValue* _Nullable)dealSectionInset:(NSArray*)insetArray
{
    if (insetArray.count != 4) {
        return nil;
    }
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([insetArray[0] floatValue], [insetArray[1] floatValue], [insetArray[2] floatValue], [insetArray[3] floatValue])];;
}

- (NSValue* _Nullable)dealItemSize:(NSArray*)itemSizeArray
{
    if (itemSizeArray.count != 2) {
        return nil;
    }
    return [NSValue valueWithCGSize:CGSizeMake([itemSizeArray[0] floatValue], [itemSizeArray[1] floatValue])];;
}

- (NSArray<NSString*> *)_otherClassMapping {
    return @[@"flowLayout",@"itemSize"];
}

- (NSArray<NSString*> *)_specialProp
{
    return @[@"sectionInset",@"itemSize"];
}

- (NSString *)classNameForIdentity:(NSString *)identity {
    // 首字母大写
    NSString *viewClassName = [NSString stringWithFormat:@"UI%@",identity];
    NSString *mapClassName = [[self _nativeClassMapping] objectForKey:viewClassName];
    viewClassName = mapClassName ? mapClassName : viewClassName;
    return viewClassName;
}

//映射
- (NSDictionary *)_nativeClassMapping {
    return @{
             @"UIInput":@"UITextField",
             @"UIWeb":@"WKWebView",
             @"UITab":@"UISegmentedControl"
             };
}

@end
