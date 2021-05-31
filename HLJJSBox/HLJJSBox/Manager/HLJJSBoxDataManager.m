 //
//  HLJJSBoxDataManager.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxDataManager.h"
#import "UIView+Yoga.h"
#import "YGLayout.h"
#import "FlexNode.h"
#import "NSString+Addition.h"

#define gObserverText @"gObserverText"
#define gObserverAttrText @"gObserverAttrText"

@implementation HLJJSBoxDataManager
- (void)parseData:(NSDictionary *)itemData superView:(UIView *)superView idMapDict:(NSMutableDictionary *_Nullable)mapDict isAppleLayout:(BOOL)isAppleLayout
{
    [itemData enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSDictionary *_Nonnull obj, BOOL * _Nonnull stop) {
        NSString *identity = key;
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj) {
                if (mapDict[identity]) {
                    UIView *view = mapDict[identity];
                    //可刷新布局
                    if ([key isEqualToString:@"layout"]) {
                        NSDictionary *layoutDictionary = obj;
                        [layoutDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSNumber class]]) {
                                FlexApplyLayoutParam(view.yoga, key, ((NSNumber*)obj).stringValue);
                            } else {
                                FlexApplyLayoutParam(view.yoga, key, obj);
                            }
                        }];
                    }
                    
                    if (![key isEqualToString:@"layout"]) {
                        [view setValue:obj forKey:key];
                    }
                    
                    if ([obj isKindOfClass:NSString.class]) {
                        NSString *text = obj;
                        if ([NSString isEmptyOrNull:text]) {
                            view.yoga.isIncludedInLayout = NO;
                        } else {
                            view.yoga.isIncludedInLayout = YES;
                        }
                    }
                    
                    if (!obj || [obj isKindOfClass:NSNull.class]) {
                        view.yoga.isIncludedInLayout = NO;
                    } else {
                        view.yoga.isIncludedInLayout = YES;
                    }
                    
                    [view.yoga markDirty];
                }
            }
        }];
    }];
        
    if (isAppleLayout) {
        superView.yoga.isEnabled = YES;
        [superView.yoga applyLayoutPreservingOrigin:YES];
    }
}

@end
