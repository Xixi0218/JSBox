//
//  UIImageView+HLJJSBox.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN

@protocol UIImageViewJSExport <JSExport>

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *source;

@end

@interface UIImageView (HLJJSBox) <UIImageViewJSExport>
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *source;
@end

NS_ASSUME_NONNULL_END
