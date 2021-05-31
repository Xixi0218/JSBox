//
//  UIImageView+HLJJSBox.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "UIImageView+HLJJSBox.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "NSString+QiniuPath.h"
#import "NSURL+QiniuPath.h"

@implementation UIImageView (HLJJSBox)


- (void)setSrc:(NSString *)src {
    self.clipsToBounds = YES;
    self.image = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize size = self.bounds.size;
        if (size.height > 0 && size.height > 0) {
            [self sd_setImageWithURL:[NSURL coverUrlForImage:src fitOutWithPointSize:size]];
        } else {
            [self sd_setImageWithURL:[NSURL URLWithString:src]];
        }
    });
    objc_setAssociatedObject(self, @selector(src), src, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)src {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSString *)source
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSource:(NSString *)source
{
    self.image = [UIImage imageNamed:source];
    objc_setAssociatedObject(self, @selector(source), source, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
