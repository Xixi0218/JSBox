//
//  NSURL+QiniuPath.h
//  iWedding
//
//  Created by v2m on 14-1-9.
//  Copyright (c) 2014年 suncloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (QiniuPath)

+(NSURL *)coverPathForVideo:(NSString*)videoPath offset:(int)offset;

+(NSURL*)coverUrlForVideo:(NSString*)videoPath height:(int)height width:(int)width fixWidth:(int)targetWidth;

+(NSURL*)coverUrlForImage:(NSString*)imagePath inBigMode:(BOOL)big;

+(NSURL*)coverUrlForImage:(NSString*)imagePath inWidth:(int)width;

+(NSURL*)coverUrlForImage:(NSString*)imagePath inHeight:(int)height;

// 注意，这里的PointSize，是点作为单位，而不是像素

//
+(NSURL*)coverUrlForImage:(NSString*)imagePath fitInWithPointSize:(CGSize)size;


+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size;

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size crop:(BOOL)crop;

///< response image format: original format.
+(NSURL*)coverUnFormatUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size;

///< response image format: If format is empty, response original format.
+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size format:(NSString*)format crop:(BOOL)crop;

///< response image format: If format is empty, response original format.
+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWithPointSize:(CGSize)size format:(NSString*)format crop:(BOOL)crop radius:(float)radius sigma:(float)sigma;

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height;

///< response image format: If format is empty, response original format. 
+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height format:(NSString*)format;

///< response image format: If format is empty, response original format.
+(NSURL*)coverUrlForImage:(NSString*)imagePath fitOutWidth:(int)width height:(int)height format:(NSString*)format crop:(BOOL)crop;

+(NSURL*)coverUrlForImage:(NSString*)imagePath fitInWidth:(int)width height:(int)height;

+(NSURL*)merchantLogoOrigin:(NSString*)imagePath shear:(NSString*)path;

+(NSURL*)previewUrlForAudio:(NSString*)audioPath;

+(NSURL*)urlForAudio:(NSString*)audioPath;

+(NSURL*)urlForImageInfo:(NSString*)imagePath;

@end
