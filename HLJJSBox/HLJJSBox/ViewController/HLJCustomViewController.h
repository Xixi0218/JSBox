//
//  HLJCustomViewController.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJCustomViewController : UIViewController
@property (nonatomic, copy) NSString *src;
//依赖的组件可能不止一个
@property (nonatomic, copy) NSArray<NSString*> *dependency;
@end

NS_ASSUME_NONNULL_END
