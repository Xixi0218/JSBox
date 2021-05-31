/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

@class YGLayout;

typedef CGFloat (*FlexScaleFunc)(CGFloat f,const char* attrName);

// 设置布局属性
void FlexApplyLayoutParam(YGLayout* layout,
                          NSString* key,
                          NSString* value);
