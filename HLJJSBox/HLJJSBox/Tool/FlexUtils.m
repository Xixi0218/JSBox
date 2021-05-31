/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexUtils.h"
#import <sys/time.h>
#import "FlexNode.h"

int String2Int(const char* s,
               NameValue table[],
               int total)
{
    //增加数字检测, 支持正整数
    if(s[0]>='0' && s[0]<='9'){
        return atoi(s);
    }
    
    for(int i=0;i<total;i++){
        if(strcmp(s,table[i].name)==0){
            return table[i].value;
        }
    }
    return table[0].value;
}


int NSString2Int(NSString* s,
                 NameValue table[],
                 int total)
{
    const char* c = [s cStringUsingEncoding:NSASCIIStringEncoding];
    return String2Int(c, table, total);
}
int NSString2GroupInt(NSString* s,
                      NameValue table[],
                      int total)
{
    int result = 0;
    NSArray* ary = [s componentsSeparatedByString:@"|"];
    NSCharacterSet* white = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for (NSString* part in ary) {
        NSString* ps = [part stringByTrimmingCharactersInSet:white];
        if(ps.length==0)
            continue;
        
        int tmp = NSString2Int(ps,
                               table,
                               total);
        result |= tmp ;
    }
    return result;
}
BOOL String2BOOL(NSString* s)
{
    return [s compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
}
