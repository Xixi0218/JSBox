//
//  HLJQiNiuPathManager.h
//  HLJCoreExtend_Example
//
//  Created by shu_pian on 2019/6/24.
//  Copyright © 2019 九阳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJQiNiuPathManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL useJPGImage;

@end

NS_ASSUME_NONNULL_END
