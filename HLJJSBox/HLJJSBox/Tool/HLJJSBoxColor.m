//
//  HLJJSBoxColor.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxColor.h"
#import "UIColor+HLJHexColor.h"

@implementation HLJJSBoxColor
+ (UIColor *)colorWithColorString:(NSString *)color {
    if ([color hasPrefix:@"#"]) {
        return [UIColor colorWithHexString:color];
    }else {
        color = [NSString stringWithFormat:@"%@Color",color];
        return [UIColor performSelector:NSSelectorFromString(color)];
    }
}
@end
