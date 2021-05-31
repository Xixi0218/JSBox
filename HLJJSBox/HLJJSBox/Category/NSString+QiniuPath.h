//
//  NSString+QiniuPath.h
//  iWedding
//
//  Created by v2m on 14-1-9.
//  Copyright (c) 2014年 suncloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QiniuPath)

+(NSString*)coverPathForVideo:(NSString*)videoPath offset:(int)offset;

+(NSString*)coverPathForVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width offset:(NSInteger)offset;

+(NSString*)coverPathForCardVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width offset:(NSInteger)offset;

+(NSString*)coverPathForVideo:(NSString*)videoPath height:(NSInteger)height width:(NSInteger)width fixWidth:(NSInteger)targetWidth;

///< response image format webp
+(NSString*)coverPathForImage:(NSString*)imagePath inBigMode:(BOOL)big;

///< response image format webp
+(NSString*)coverPathForImage:(NSString*)imagePath inWidth:(NSInteger)width;

///< response image format webp
+(NSString *)coverPathForImage:(NSString *)imagePath inHeight:(NSInteger)height;

///< response image format webp
//+(NSString*)coverPathForImage:(NSString*)imagePath inLength:(NSInteger)length;

///< response image format webp
+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height;

///< response image format: If format is empty, response original format. 
+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height format:(NSString*)format;

///< response image format: If format is empty, response original format.
+(NSString*)coverPathForImage:(NSString*)imagePath fitOutWidth:(NSInteger)width height:(NSInteger)height format:(NSString*)format crop:(BOOL)crop;

///< response image format webp
+(NSString*)coverPathForImage:(NSString*)imagePath fitInWidth:(NSInteger)width height:(NSInteger)height;

+(NSString*)pathForImageInfo:(NSString*)imagePath;

@end
