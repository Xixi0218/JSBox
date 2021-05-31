//
//  NSString+QiniuPath.m
//  iWedding
//
//  Created by v2m on 14-1-9.
//  Copyright (c) 2014年 suncloud. All rights reserved.
//

#import "NSString+QiniuPath.h"
#import "NSString+Addition.h"
#import "HLJQiNiuPathManager.h"
#import <UIKit/UIKit.h>

#define KimageMaxHeight ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale * 2.5)
#define KimageMaxWidth ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale * 1.5)

@implementation NSString (QiniuPath)


+(NSString*)coverPathForVideo:(NSString*)videoPath offset:(int)offset
{
    return [videoPath stringByAppendingFormat:@"?vframe/jpg/offset/%d/rotate/auto",offset];
}

+(NSString*)coverPathForVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width offset:(NSInteger)offset
{
    if (width < 1)
        return nil;
    
    CGFloat rate = (CGFloat)width / 320.0;
    return [videoPath stringByAppendingFormat:@"?vframe/jpg/offset/%ld/w/%d/h/%ld",(long)offset,320,(long)((CGFloat)height / rate)];
}

+(NSString*)coverPathForCardVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width offset:(NSInteger)offset
{
    if (width < 1)
        return nil;
    
    CGFloat rate = (CGFloat)width / 200.0;
    return [videoPath stringByAppendingFormat:@"?vframe/jpg/offset/%ld/w/%d/h/%ld",(long)offset,200,(long)((CGFloat)height / rate)];
}


+(NSString*)coverPathForVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width fixWidth:(NSInteger)targetWidth
{
    if (targetWidth < 1 || width < 1)
        return nil;
    
    CGFloat rate = (CGFloat)width / (CGFloat)targetWidth;
    return [videoPath stringByAppendingFormat:@"?vframe/jpg/offset/3/w/%ld/h/%ld",(long)targetWidth,(long)((CGFloat)height / rate)];
}

+(NSString*)coverPathForImage:(NSString*)imagePath inBigMode:(BOOL)big
{
    int maxWidth = big?960:640;
    
    return [NSString coverPathForImage:imagePath inWidth:maxWidth];
}

+(NSString *)coverPathForImage:(NSString *)imagePath inWidth:(NSInteger)width {
    return [self coverPathForImage:imagePath fitInWidth:width height:KimageMaxHeight];
}

+(NSString *)coverPathForImage:(NSString *)imagePath inHeight:(NSInteger)height {
    return [self coverPathForImage:imagePath fitInWidth:KimageMaxHeight height:height];
}

+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height
{
    return [self coverPathForImage:imagePath fitOutWidth:width height:height format:@"webp" crop:YES];
}

+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height format:(NSString*)format {
    return [self coverPathForImage:imagePath fitOutWidth:width height:height format:format crop:YES];
}

+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height format:(NSString*)format crop:(BOOL)crop {
    if(imagePath == nil || ![imagePath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if(height > KimageMaxHeight) {
        width = width*KimageMaxHeight/height;
        height = KimageMaxHeight;
    }
    if(width > KimageMaxWidth) {
        height = height*KimageMaxWidth/width;
        width = KimageMaxWidth;
    }
    
    NSString* path = imagePath;
    if(crop) {
        if([path rangeOfString:@"?"].location != NSNotFound) {
            NSString* scaleStr;
            if ([path hlj_shouldAddPipe]) {
                if ([path hlj_shouldAddUnoptimize]) {
                    scaleStr = [NSString stringWithFormat:@"/unoptimize/1%%7cimageView2/1/w/%ld/h/%ld/q/85", (long)width, (long)height];
                } else {
                    scaleStr = [NSString stringWithFormat:@"%%7cimageView2/1/w/%ld/h/%ld/q/85", (long)width, (long)height];
                }
            } else {
                scaleStr = [NSString stringWithFormat:@"&imageView2/1/w/%ld/h/%ld/q/85", (long)width, (long)height];
            }
            path = [path stringByAppendingString:scaleStr];
        } else {
            path = [path stringByAppendingFormat:@"?imageView2/1/w/%ld/h/%ld/q/85",(long)width,(long)height];
        }
    } else {
        if([path rangeOfString:@"?"].location != NSNotFound) {
            NSString* scaleStr;
            if ([path hlj_shouldAddPipe]) {
                if ([path hlj_shouldAddUnoptimize]) {
                    scaleStr = [NSString stringWithFormat:@"/unoptimize/1%%7cimageView2/3/w/%ld/h/%ld/q/85", (long)width, (long)height];
                } else {
                    scaleStr = [NSString stringWithFormat:@"%%7cimageView2/3/w/%ld/h/%ld/q/85", (long)width, (long)height];
                }
            } else {
                scaleStr = [NSString stringWithFormat:@"&imageView2/3/w/%ld/h/%ld/q/85", (long)width, (long)height];
            }
            path = [path stringByAppendingString:scaleStr];
        } else {
            path = [path stringByAppendingFormat:@"?imageView2/3/w/%ld/h/%ld/q/85",(long)width,(long)height];
        }
    }
    if (![NSString isEmptyOrNull:format]) {
        path = [path hlj_stringAppendFormat:format];
    }
    return path;
}

+(NSString*)coverPathForImage:(NSString*)imagePath fitInWidth:(NSInteger)width height:(NSInteger)height
{
    if(imagePath == nil || ![imagePath isKindOfClass:[NSString class]])
        return nil;
    
    if(height > KimageMaxHeight) {
        width = width*KimageMaxHeight/height;
        height = KimageMaxHeight;
    }
    if(width > KimageMaxWidth) {
        height = height*KimageMaxWidth/width;
        width = KimageMaxWidth;
    }
    
    NSString* path = imagePath;
    if([path rangeOfString:@"?"].location != NSNotFound) {
        NSString* scaleStr;
        if ([path hlj_shouldAddPipe]) {
            if ([path hlj_shouldAddUnoptimize]) {
                scaleStr = [NSString stringWithFormat:@"/unoptimize/1%%7cimageView2/2/w/%ld/h/%ld/q/85", (long)width, (long)height];
            } else {
                scaleStr = [NSString stringWithFormat:@"%%7cimageView2/2/w/%ld/h/%ld/q/85", (long)width, (long)height];
            }
        } else {
            scaleStr = [NSString stringWithFormat:@"&imageView2/2/w/%ld/h/%ld/q/85", (long)width, (long)height];
        }
        path = [path stringByAppendingString:scaleStr];
        path = [path hlj_stringAppendFormat:@"webp"];
    } else {
        path = [path stringByAppendingFormat:@"?imageView2/2/w/%ld/h/%ld/q/85",(long)width,(long)height];
        path = [path hlj_stringAppendFormat:@"webp"];
    }
    return path;
}

+(NSString*)pathForImageInfo:(NSString*)imagePath
{
    NSString *path = imagePath;
    if([path rangeOfString:@"?"].location != NSNotFound) {
        if ([path hlj_shouldAddPipe]) {
            if ([path hlj_shouldAddUnoptimize]) {
                path = [path stringByAppendingString:@"/unoptimize/1%7cimageInfo"];
            } else {
                path = [path stringByAppendingString:@"%7cimageInfo"];
            }
        } else {
            path = [path stringByAppendingString:@"&imageInfo"];
        }
    } else {
        path = [path stringByAppendingString:@"?imageInfo"];
    }
    
    return path;
}

- (BOOL)hlj_shouldAddPipe {
    return [self containsString:@"imageslim"]
    || [self containsString:@"imageView2"]
    || [self containsString:@"imageMogr2"]
    || [self containsString:@"watermark"]
    || [self containsString:@"animate"]
    || [self containsString:@"vframe"]
    || [self containsString:@"vsample"];
}

- (BOOL)hlj_shouldAddUnoptimize {
    return ([self containsString:@"imageView2"] || [self containsString:@"imageMogr2"]) && [self containsString:@".gif"];
}

- (NSString *)hlj_stringAppendFormat:(NSString *)format {
    NSString *result;
    if ([format isEqualToString:@"webp"] &&
        !([self rangeOfString:@".png"].length > 0 || [self rangeOfString:@".gif"].length) &&
        [HLJQiNiuPathManager sharedInstance].useJPGImage) {
        result = [self stringByAppendingFormat:@"/format/%@", @"jpg"];
    } else {
        result = [self stringByAppendingFormat:@"/format/%@", format];
    }
    // gif 后缀加上清晰度
    if ([self rangeOfString:@".gif"].length > 0) {
        result = [result stringByAppendingFormat:@"/unoptimize/1"];
    }
    return result;
}

@end
