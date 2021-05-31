//
//  NSMutableDictionary+HLJJSBoxSafe.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (HLJJSBoxSafe)
- (void)hlj_safeSetObject:(id)object forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
