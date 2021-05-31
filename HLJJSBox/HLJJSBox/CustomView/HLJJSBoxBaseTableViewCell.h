//
//  HLJJSBoxBaseTableViewCell.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@class HLJJSBoxEngine;
@interface HLJJSBoxBaseTableViewCell : UITableViewCell
- (instancetype)initWithValue:(JSManagedValue*)managedValue engine:(HLJJSBoxEngine*)engine reuseIdentifier:(NSString*)reuseIdentifier;
- (void)updateData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
