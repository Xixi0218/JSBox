//
//  DeviceInfo.m
//  iWedding
//
//  Created by v2m on 13-1-8.
//  Copyright (c) 2013年 suncloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
#import <AVFoundation/AVFoundation.h>
//#include <sys/socket.h>
#import <sys/sysctl.h>

@implementation DeviceInfo

+(float)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(float)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(float)screenScale
{
    return [UIScreen mainScreen].scale;
}

+(BOOL)isIOS5
{
    static BOOL isI5 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isI5 = ([UIDevice currentDevice].systemVersion.intValue < 6);
    });
    return isI5;
}

+(BOOL)isBelowIOS7
{
    static BOOL isBelowI7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isBelowI7 = ([UIDevice currentDevice].systemVersion.intValue < 7);
    });
    return isBelowI7;
}

+(BOOL)isIOS7
{
    static BOOL isI7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isI7 = ([UIDevice currentDevice].systemVersion.intValue > 6);
    });
    return isI7;
}

+(BOOL)isIOS7_0
{
    static BOOL isI7_0 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([DeviceInfo isIOS7]) {
            NSString* secondVersion = [[UIDevice currentDevice].systemVersion substringWithRange:NSMakeRange(2, 1)];
            if ([secondVersion integerValue] == 0)
                isI7_0 = YES;
        }
    });
    return isI7_0;
}

+(BOOL)isBelowIOS8
{
    static BOOL isBelowI8 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isBelowI8 = ([UIDevice currentDevice].systemVersion.intValue < 8);
    });
    return isBelowI8;
}

+(BOOL)isIOS8
{
    static BOOL isI8 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([DeviceInfo isIOS7]) {
            isI8 = ([UIDevice currentDevice].systemVersion.intValue > 7);
        }
    });
    return isI8;
}

+(float)ios67height
{
    if ([DeviceInfo isIOS7])
        return 20;
    return 0;
}

+ (NSString *) platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

@end
