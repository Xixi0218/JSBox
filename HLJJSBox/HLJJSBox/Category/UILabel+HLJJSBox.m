//
//  UILabel+HLJJSBox.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "UILabel+HLJJSBox.h"

@implementation UILabel (HLJJSBox)

- (NSInteger)align {
    return self.textAlignment;
}
- (void)setAlign:(NSInteger)align {
    self.textAlignment = align;
}

- (NSInteger)lines {
    return self.numberOfLines;
}

- (void)setLines:(NSInteger)lines {
    self.numberOfLines = lines;
}

- (BOOL)autoFontSize {
    return self.adjustsFontSizeToFitWidth;
}

- (void)setAutoFontSize:(BOOL)autoFontSize {
    self.adjustsFontSizeToFitWidth = autoFontSize;
}

@end
