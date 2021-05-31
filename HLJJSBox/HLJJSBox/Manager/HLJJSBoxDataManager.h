//
//  HLJJSBoxDataManager.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJJSBoxDataManager : NSObject
- (void)parseData:(NSDictionary *)itemData superView:(UIView *)superView idMapDict:(NSMutableDictionary *_Nullable)mapDict isAppleLayout:(BOOL)isAppleLayout;
@end

NS_ASSUME_NONNULL_END
