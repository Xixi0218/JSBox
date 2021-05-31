/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexNode.h"
#import "UIView+Yoga.h"
#import "FlexUtils.h"

#pragma mark - Name values

CGFloat scaleLinear(CGFloat f,const char* attrName);

// 全局变量
static float gfScaleFactor = 1.0f;
static float gfScaleOffset = 0;
static FlexScaleFunc gScaleFunc = scaleLinear ;
static NSString* gResourceSuffix = nil;

// 布局文件索引，Flexname -> Http Url
static NSDictionary* gFlexIndex = nil;
static NSString* gBaseUrl = nil;

static NameValue _direction[] =
{{"inherit", YGDirectionInherit},
 {"ltr", YGDirectionLTR},
 {"rtl", YGDirectionRTL},
};
static NameValue _flexDirection[] =
{   {"col", YGFlexDirectionColumn},
    {"col-reverse", YGFlexDirectionColumnReverse},
    {"row", YGFlexDirectionRow},
    {"row-reverse", YGFlexDirectionRowReverse},
};
static NameValue _justify[] =
{   {"flex-start", YGJustifyFlexStart},
    {"center", YGJustifyCenter},
    {"flex-end", YGJustifyFlexEnd},
    {"space-between", YGJustifySpaceBetween},
    {"space-around", YGJustifySpaceAround},
};
static NameValue _align[] =
{   {"auto", YGAlignAuto},
    {"flex-start", YGAlignFlexStart},
    {"center", YGAlignCenter},
    {"flex-end", YGAlignFlexEnd},
    {"stretch", YGAlignStretch},
    {"baseline", YGAlignBaseline},
    {"space-between", YGAlignSpaceBetween},
    {"space-around", YGAlignSpaceAround},
};
static NameValue _positionType[] =
{{"relative", YGPositionTypeRelative},
    {"absolute", YGPositionTypeAbsolute},
};

static NameValue _wrap[] =
{{"no-wrap", YGWrapNoWrap},
    {"wrap", YGWrapWrap},
    {"wrap-reverse", YGWrapWrapReverse},
};
static NameValue _overflow[] =
{{"visible", YGOverflowVisible},
    {"hidden", YGOverflowHidden},
    {"scroll", YGOverflowScroll},
};
static NameValue _display[] =
{{"flex", YGDisplayFlex},
    {"none", YGDisplayNone},
};

static CGFloat ScaleSize(const char* s,
                         const char* attrName)
{
    CGFloat f;
    if(s[0]=='*')
    {
        f = gScaleFunc(atof(s+1),attrName);
    }else{
        f = atof(s);
    }
    return f;
}

static YGValue String2YGValue(const char* s,
                              const char* attrName)
{
    if(strcmp(s, "none")==0)
    {
        return (YGValue) { .value = NAN, .unit = YGUnitUndefined };
        
    }else if(strcmp(s, "auto")==0){
        
        return (YGValue) { .value = NAN, .unit = YGUnitAuto };
        
    }
    
    int len = (int) strlen(s) ;
    if(len==0||len>100){
        NSLog(@"Flexbox: wrong number or pecentage value:%s",s);
        return YGPointValue(0);
    }
    if( s[len-1]=='%' ){
        char dest[100];
        strncpy(dest, s, len-1);
        dest[len-1]=0;
        return YGPercentValue(ScaleSize(dest,attrName));
    }
    return YGPointValue(ScaleSize(s,attrName));
}

static void ApplyLayoutParam(YGLayout* layout,
                             NSString* key,
                             NSString* value)
{
    const char* k = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char* v = [value cStringUsingEncoding:NSASCIIStringEncoding];
 
#define SETENUMVALUE(item,table,type)      \
if(strcmp(k,#item)==0)                \
{                                        \
layout.item=(type)String2Int(v,table,sizeof(table)/sizeof(NameValue));                  \
return;                                  \
}                                        \

#define SETYGVALUE(item)       \
if(strcmp(k,#item)==0)          \
{                               \
layout.item=String2YGValue(v,k);\
return;                         \
}                               \

#define SETNUMVALUE(item)       \
if(strcmp(k,#item)==0)          \
{                               \
layout.item=ScaleSize(v,k);     \
return;                         \
}

SETENUMVALUE(direction,_direction,YGDirection);
SETENUMVALUE(flexDirection,_flexDirection,YGFlexDirection);
SETENUMVALUE(justifyContent,_justify,YGJustify);
SETENUMVALUE(alignContent,_align,YGAlign);
SETENUMVALUE(alignItems,_align,YGAlign);
SETENUMVALUE(alignSelf,_align,YGAlign);
SETENUMVALUE(position,_positionType,YGPositionType);
SETENUMVALUE(flexWrap,_wrap,YGWrap);
SETENUMVALUE(overflow,_overflow,YGOverflow);
SETENUMVALUE(display,_display,YGDisplay);

    SETNUMVALUE(flex);
    SETNUMVALUE(flexGrow);
    SETNUMVALUE(flexShrink);
    
    SETYGVALUE(flexBasis);
    
    SETYGVALUE(left);
    SETYGVALUE(top);
    SETYGVALUE(right);
    SETYGVALUE(bottom);
    SETYGVALUE(start);
    SETYGVALUE(end);

    SETYGVALUE(marginLeft);
    SETYGVALUE(marginTop);
    SETYGVALUE(marginRight);
    SETYGVALUE(marginBottom);
    SETYGVALUE(marginStart);
    SETYGVALUE(marginEnd);
    SETYGVALUE(marginHorizontal);
    SETYGVALUE(marginVertical);
    SETYGVALUE(margin);
    
    SETYGVALUE(paddingLeft);
    SETYGVALUE(paddingTop);
    SETYGVALUE(paddingRight);
    SETYGVALUE(paddingBottom);
    SETYGVALUE(paddingStart);
    SETYGVALUE(paddingEnd);
    SETYGVALUE(paddingHorizontal);
    SETYGVALUE(paddingVertical);
    SETYGVALUE(padding);
    
    SETNUMVALUE(borderLeftWidth);
    SETNUMVALUE(borderTopWidth);
    SETNUMVALUE(borderRightWidth);
    SETNUMVALUE(borderBottomWidth);
    SETNUMVALUE(borderStartWidth);
    SETNUMVALUE(borderEndWidth);
    SETNUMVALUE(borderWidth);
    
    SETYGVALUE(width);
    SETYGVALUE(height);
    SETYGVALUE(minWidth);
    SETYGVALUE(minHeight);
    SETYGVALUE(maxWidth);
    SETYGVALUE(maxHeight);
    
    SETNUMVALUE(aspectRatio);
    
    NSLog(@"Flexbox: not supported layout attr - %@",key);
}

//增加对单一flex属性的支持，相当于同时设置flexGrow和flexShrink
void FlexApplyLayoutParam(YGLayout* layout,
                          NSString* key,
                          NSString* value)
{
    if( [@"margin" compare:key options:NSLiteralSearch]==NSOrderedSame){
        
        NSArray* ary = [value componentsSeparatedByString:@"/"];
        if( ary.count==1 ){
            ApplyLayoutParam(layout, key, value);
        }else if(ary.count==4){
            ApplyLayoutParam(layout, @"marginLeft", ary[0]);
            ApplyLayoutParam(layout, @"marginTop", ary[1]);
            ApplyLayoutParam(layout, @"marginRight", ary[2]);
            ApplyLayoutParam(layout, @"marginBottom", ary[3]);
        }
        
    }else if( [@"padding" compare:key options:NSLiteralSearch]==NSOrderedSame){
        
        NSArray* ary = [value componentsSeparatedByString:@"/"];
        if( ary.count==1 ){
            ApplyLayoutParam(layout, key, value);
        }else if(ary.count==4){
            ApplyLayoutParam(layout, @"paddingLeft", ary[0]);
            ApplyLayoutParam(layout, @"paddingTop", ary[1]);
            ApplyLayoutParam(layout, @"paddingRight", ary[2]);
            ApplyLayoutParam(layout, @"paddingBottom", ary[3]);
        }
        
    }else{
        ApplyLayoutParam(layout, key, value);
    }
}

void FlexSetCustomScale(FlexScaleFunc scaleFunc)
{
    if(scaleFunc != NULL){
        gScaleFunc = scaleFunc ;
    }
}

CGFloat scaleLinear(CGFloat f,const char* attrName)
{
    return f*gfScaleFactor+gfScaleOffset;
}
