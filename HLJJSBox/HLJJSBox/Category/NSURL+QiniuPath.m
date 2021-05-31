//
//  NSURL+QiniuPath.m
//  iWedding
//
//  Created by v2m on 14-1-9.
//  Copyright (c) 2014年 suncloud. All rights reserved.
//

#import "NSURL+QiniuPath.h"
#import "NSString+QiniuPath.h"
#import "DeviceInfo.h"
#import "NSString+Addition.h"

@implementation NSURL (QiniuPath)

+(NSURL *)coverPathForVideo:(NSString*)videoPath offset:(int)offset
{
    return [NSURL URLWithString:[NSString coverPathForVideo:videoPath offset:offset]];
}

+(NSURL*)coverUrlForVideo:(NSString*)videoPath height:(int)height width:(int)width fixWidth:(int)targetWidth
{
    return [NSURL URLWithString:[NSString coverPathForVideo:videoPath height:height width:width fixWidth:targetWidth]];
}

+(NSURL *)coverUrlForImage:(NSString *)imagePath inBigMode:(BOOL)big
{
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath inBigMode:big]];
}

+(NSURL *)coverUrlForImage:(NSString *)imagePath inWidth:(int)width
{
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath inWidth:width]];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath inHeight:(int)height
{
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath inHeight:height]];
}


+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size {
    
    return [self coverUrlForImage:imagePath fitOutWithPointSize:size crop:YES];
    
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size crop:(BOOL)crop{
    NSString *formatStr = @"webp";
    return [self coverUrlForImage:imagePath fitOutWithPointSize:size format:formatStr crop:crop];
}

+(NSURL *)coverUnFormatUrlForImage:(NSString *)imagePath fitOutWithPointSize:(CGSize)size {
    return [self coverUrlForImage:imagePath fitOutWithPointSize:size format:nil crop:YES];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size format:(NSString*)format crop:(BOOL)crop {
    return [self coverUrlForImage:imagePath fitOutWidth:size.width*kScreenScale height:size.height*kScreenScale format:format crop:crop];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size format:(NSString*)format crop:(BOOL)crop radius:(float)radius sigma:(float)sigma  {
    
    NSString *path = [imagePath stringByAppendingString:@"?imageMogr2"];
    
    CGFloat width = size.width * kScreenScale;
    CGFloat height = size.height * kScreenScale;
    
    if (width > 0 && height > 0) {
        path = [path stringByAppendingFormat:@"/thumbnail/!%.0fx%0.fr",width,height];
    }
    
    if ([NSString isEmptyOrNull:format]) {
        path = [path stringByAppendingString:@"/format/webp"];
    } else {
        path = [path stringByAppendingFormat:@"/format/%@",format];
    }
    
    if (crop && width>0 && height>0) {
        path = [path stringByAppendingFormat:@"/gravity/Center/crop/%.0fx%0.f",width,height];
    }
    
    if (radius>0 && sigma>0) {
        path = [path stringByAppendingFormat:@"/blur/%.0fx%.0f",radius,sigma];
    }
    
    NSString *newUrlString = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:newUrlString];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height
{
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath fitOutWidth:width height:height]];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height format:(NSString*)format {
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath fitOutWidth:width height:height format:format]];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height format:(NSString*)format crop:(BOOL)crop {
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath fitOutWidth:width height:height format:format crop:crop]];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitInWithPointSize:(CGSize)size {
    return [NSURL coverUrlForImage:imagePath fitInWidth:size.width*kScreenScale height:size.height*kScreenScale];
}

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitInWidth:(int)width height:(int)height
{
    return [NSURL URLWithString:[NSString coverPathForImage:imagePath fitInWidth:width height:height]];
}

+(NSURL*)merchantLogoOrigin:(NSString*)imagePath shear:(NSString*)shearPath
{
    if (shearPath && [shearPath isKindOfClass:[NSString class]]) {
        NSRange range = [shearPath rangeOfString:@"NaN"];
        if(range.location == NSNotFound) {
            return [NSURL URLWithString:[shearPath stringByAppendingString:@"%7CimageView/1/w/248/h/148/format/webp"]];
        }
    }
    
    if (imagePath) {
        return [NSURL URLWithString:[imagePath stringByAppendingString:@"?imageView/1/w/248/h/148/format/webp"]];
    }
    
    return nil;
}

+(NSURL*)previewUrlForAudio:(NSString*)audioPath
{
    NSString*  urlStr = [audioPath stringByAppendingString:@"?avthumb/mp3/ab/32k/ar/22050"];
    NSURL* url = [NSURL URLWithString:urlStr];
    if(url==nil) {
        //urlStr = [urlStr stringByRemovingPercentEncoding];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:urlStr];
    }
    return url;
}

+(NSURL*)urlForAudio:(NSString*)audioPath
{
    NSString*  urlStr = [audioPath stringByAppendingString:@"?avthumb/mp3"];
    NSURL* url = [NSURL URLWithString:urlStr];
    if(url == nil) {
        //urlStr = [urlStr stringByRemovingPercentEncoding];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:urlStr];
    }
    return url;
}

+(NSURL*)urlForImageInfo:(NSString*)imagePath
{
    return [NSURL URLWithString:[NSString pathForImageInfo:imagePath]];
}
@end
