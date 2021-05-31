//
//  HLJJSBoxHttpManager.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJJSBoxHttpManager : NSObject
- (void)callRequestWithEngine:(JSValue *)engine;
@end

NS_ASSUME_NONNULL_END
