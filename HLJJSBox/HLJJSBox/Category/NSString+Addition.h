//
//  NSString+Addition.h
//  iHealth
//
//  Created by v2m on 12-8-31.
//  Copyright (c) 2012年 SunCloud. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <UIKit/UIKit.h>

@interface NSString (Addition)

+(NSInteger)gbkLengthForString:(NSString*)utf8String;
+(NSString*)weekDayFromIndex:(NSInteger)index;
+(NSString*)uuid;

+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;
- (NSString *)stringFromMD5;

+(BOOL)isEmptyOrNull:(NSString*)str;
- (BOOL)isEmptyOrNull;

+(BOOL)isOnlineUrl:(NSString*)url;

// 中文算两个单位长度，其他字符算一个单位长度
-(NSUInteger)chineseLength;
-(NSString*)subStringToChineseIndex:(NSUInteger)index;
///< 兼容港澳台10位，大陆一代15位，二代18位
+(BOOL)validateIdentityCard:(NSString *)identityCard;
+(BOOL)validateEmail:(NSString *)email;

+(NSDictionary*)alignJustifiedAttributes;

+(NSString *)cardNoToShow:(NSString *)bankNum;
+(NSString *)cardNoToNormal:(NSString *)bankNum;

- (CGSize)hljSzeWithFont:(UIFont *)font;

- (CGSize)hljSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)hljSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)hljSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (void)hljDrawAtPoint:(CGPoint)point withFont:(UIFont *)font;

- (void)hljDrawInRect:(CGRect)rect  withFont:(UIFont *)font color:(UIColor *)color  lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

- (void)hljDrawInRect:(CGRect)rect withFont:(UIFont *)font;

+ (NSString*)addUrlParams:(NSDictionary*)params toUrlString:(NSString*)urlString;

///< 生成金额字符串 (1.00 -> @"1", 1.01 -> @"1.01", 1.0111 -> @"1.01")
+ (instancetype)stringWithMoney:(CGFloat)money;

///< 获取字符串包含某一字符串的所有位置
- (NSArray<NSValue *> *)rangesOfString:(NSString *)searchString;

@end
