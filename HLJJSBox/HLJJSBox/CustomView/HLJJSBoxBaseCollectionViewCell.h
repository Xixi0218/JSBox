//
//  HLJJSBoxBaseCollectionViewCell.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/18.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@class HLJJSBoxEngine;
@interface HLJJSBoxBaseCollectionViewCell : UICollectionViewCell
- (instancetype)initWithValue:(JSManagedValue*)managedValue engine:(HLJJSBoxEngine*)engine data:(NSDictionary*)data;
@property (nonatomic, strong) JSManagedValue *managedValue;
@property (nonatomic, weak) HLJJSBoxEngine *engine;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSDictionary *selectData;
- (void)updateData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
