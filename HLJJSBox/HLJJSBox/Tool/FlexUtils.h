/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <UIKit/UIKit.h>

typedef struct {
    const char* name;
    int   value;
} NameValue;

// 在表中查询s字符串，将其转换成int值
int String2Int(const char* s,
               NameValue table[],
               int total);

int NSString2Int(NSString* s,
                 NameValue table[],
                 int total);

int NSString2GroupInt(NSString* s,
                      NameValue table[],
                      int total);

// 字符串转换BOOL
BOOL String2BOOL(NSString* s);
