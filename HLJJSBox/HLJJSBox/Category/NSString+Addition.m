//
//  NSString+Addition.m
//  iHealth
//
//  Created by v2m on 12-8-31.
//  Copyright (c) 2012年 SunCloud. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Addition)

+(NSInteger)gbkLengthForString:(NSString*)utf8String
{
    NSInteger i,n=[utf8String length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[utf8String characterAtIndex:i];
        if(isblank(c))
            b++;
        else if(isascii(c))
            a++;
        else
            l++;
    }
    if(a==0 && l==0) return 0;
    return l+(NSInteger)ceilf((float)(a+b)/2.0);
}

+(NSString*)weekDayFromIndex:(NSInteger)index
{
    if (index == 1)
        return NSLocalizedString(@"星期日", @"星期日全称");
    else if (index == 2)
        return NSLocalizedString(@"星期一", @"星期一全称");
    else if (index == 3)
        return NSLocalizedString(@"星期二", @"星期二全称");
    else if (index == 4)
        return NSLocalizedString(@"星期三", @"星期三全称");
    else if (index == 5)
        return NSLocalizedString(@"星期四", @"星期四全称");
    else if (index == 6)
        return NSLocalizedString(@"星期五", @"星期五全称");
    else if (index == 7)
        return NSLocalizedString(@"星期六", @"星期六全称");
    return @"";
}

+(NSString*)uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (NSString *)md5:(NSString *)str
{
    if (!str) 
        return nil;

    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (NSString *)sha1:(NSString *)str
{
    if (!str)
        return nil;
    
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)stringFromMD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(BOOL)isEmptyOrNull:(NSString*)str
{
    return str == nil || ![str isKindOfClass:[NSString class]] || str.length <= 0 || [str isEqualToString:@"(null)"];
}

- (BOOL)isEmptyOrNull
{
    return self == nil || ![self isKindOfClass:[NSString class]] || self.length <= 0;
}

- (BOOL)isEqualToNumber:(NSNumber *)otherNumber {
    NSNumber *number = @([self integerValue]);
    NSNumber *mOtherNumber = @([otherNumber integerValue]);
    return [number isEqualToNumber:mOtherNumber];
}

+(BOOL)isOnlineUrl:(NSString*)url
{
    if([NSString isEmptyOrNull:url])
        return NO;
    
    if([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        return YES;
    } else {
        return NO;
    }
}

// 中文算2个单位长度，其他字符算一个单位长度
-(NSUInteger)chineseLength {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger length=[self length];
    NSInteger currentStringSize=0;
    
    for (NSInteger i=0;i<length;i++) {
        
        NSString *subString  = [self substringWithRange:NSMakeRange( i, 1)] ;
        
        NSArray *matches = [regex matchesInString:subString options:0 range:NSMakeRange(0, 1)];
        
        if (matches.count > 0) {
            currentStringSize+=2;
        }else {
            currentStringSize+=1;
        }
    }
    
    return currentStringSize;
}

-(NSString*)subStringToChineseIndex:(NSUInteger)index {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger length=[self length];
    NSInteger currentStringSize=0;
    
    NSString *retStr = [self copy];
    for (int i=0;i<length;i++) {
        
        NSString *subString  = [self substringWithRange:NSMakeRange( i, 1)] ;
        NSArray *matches = [regex matchesInString:subString options:0 range:NSMakeRange(0, 1)];
        
        if (matches.count > 0) {
            if(currentStringSize + 2 > index) {
                retStr = [self substringToIndex:i];
                break;
            }
            currentStringSize+=2;
        }else {
            if(currentStringSize + 1 > index) {
                retStr = [self substringToIndex:i];
                break;
            }
            currentStringSize+=1;
        }
    }
    
    return retStr;
}


+(BOOL)validateIdentityCard:(NSString *)identityCard {
    NSString *regex2 = @"^(\\d{10}$|^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSDictionary*)alignJustifiedAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    return @{NSParagraphStyleAttributeName:paragraphStyle,
             NSBaselineOffsetAttributeName:@0.0f};
}

// 正常号转银行卡号 － 增加4位间的空格
+(NSString *)cardNoToShow:(NSString *)bankNum
{
    NSString *tmpStr = [self cardNoToNormal:bankNum];
    
    NSInteger size = ((NSInteger)tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (NSInteger n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    if(tmpStr.length%4 > 0) {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    }
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

// 银行卡号转正常号 － 去除4位间的空格
+(NSString*)cardNoToNormal:(NSString*)bankNum
{
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return bankNum;
}




- (CGSize)hljSzeWithFont:(UIFont *)font{

    CGSize detailsLabelSize = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    return detailsLabelSize;
}


- (CGSize)hljSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{

    CGSize detailsLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return detailsLabelSize;

}

- (CGSize)hljSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    CGSize detailsLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return detailsLabelSize;
}

- (CGSize)hljSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode{

    CGSize detailsLabelSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return detailsLabelSize;
}


- (void)hljDrawAtPoint:(CGPoint)point withFont:(UIFont *)font{

     [self drawAtPoint:point withAttributes:@{NSFontAttributeName: font}];
    
}

- (void)hljDrawInRect:(CGRect)rect  withFont:(UIFont *)font color:(UIColor *)color  lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment{
    
    if(CGRectIsEmpty(rect) || font == nil || color == nil)
        return;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = alignment;

    [self drawInRect:rect withAttributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:color}];

}


- (void)hljDrawInRect:(CGRect)rect withFont:(UIFont *)font{

    [self drawInRect:rect withAttributes:@{NSFontAttributeName: font}];

}

+ (NSString*)addUrlParams:(NSDictionary*)params toUrlString:(NSString*)urlString; {
    
    NSMutableString *url;
    
    unichar lastChar = [urlString characterAtIndex:urlString.length-1];
    if([urlString rangeOfString:@"?"].location == NSNotFound) {
        // 不含?,则在最后加入‘?’
        url = [NSMutableString stringWithFormat:@"%@?", urlString];
    } else if (lastChar == '&') {
        // 含?,且最后一个字符是‘&’
        url = [NSMutableString stringWithString:urlString];
    } else {
        // 含?,且最后一个字符不是'&',则在最后加入‘&’
        url = [NSMutableString stringWithFormat:@"%@&", urlString];
    }
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [url appendFormat:@"%@=%@&", key, obj];
    }];

    return url;
}

+ (instancetype)stringWithMoney:(CGFloat)money {
    double doubleMoney = money;
    doubleMoney = round(doubleMoney * 100) /100.0;
    if (doubleMoney > floor(doubleMoney)) {
        return [NSString stringWithFormat:@"%0.2f", doubleMoney];
    }
    return [NSString stringWithFormat:@"%0.0f", doubleMoney];
}
    
- (NSArray<NSValue *> *)rangesOfString:(NSString *)searchString {
    
    NSMutableArray *ranges = [NSMutableArray array];
    NSString *temp = self;
    NSRange lastRange = NSMakeRange(0, 0);
    while ([temp containsString: searchString]) {
        NSRange range = [temp rangeOfString:searchString];
        range.location += NSMaxRange(lastRange);
        [ranges addObject:[NSValue valueWithRange:range]];
        lastRange = range;
        temp = [self substringFromIndex: NSMaxRange(lastRange)];
    }
    return ranges;
}


@end
