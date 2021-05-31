//
//  HLJJSBoxHttpManager.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/16.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxHttpManager.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+HLJJSBoxSafe.h"

@interface HLJJSBoxHttpManager ()
@property (nonatomic,strong) AFURLSessionManager *sessionManager;
@end

@implementation HLJJSBoxHttpManager

- (void)callRequestWithEngine:(JSValue *)engine {
    // 解析参数
    NSString *method = [engine[@"method"] toString];
    method = method ? method : @"GET";
    NSString *url = [engine[@"url"] toString];
    NSDictionary *form = [engine[@"form"] toDictionary];
    NSDictionary *header = [engine[@"header"] toDictionary];
    NSDictionary *body = [engine[@"body"] toDictionary];
    JSValue *jsFunc = engine[@"handler"];
    
    // 做一层判断
    if (!url) {
        NSLog(@"$http 必须传url");
        return;
    }
    
    // request
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:url parameters:form error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置request header
    if (header) {
        for (NSString *key in header.allKeys) {
            [request setValue:header[key] forHTTPHeaderField:key];
        }
    }
    // 设置request body
    if (body) {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:bodyData];
    }
    NSURLSessionDataTask *task =  [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsArgs = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];;
            [jsFunc callWithArguments:@[jsArgs]];
        }
    }];
    [task resume];
}


- (NSDictionary *)_getJsArgumentsWithResponse:(NSHTTPURLResponse *)response reponseObjectString:(NSString *)responseString error:(NSError *)error {
    // js dict
    NSMutableDictionary *jsArguments = [NSMutableDictionary dictionary];
    
    // response
    NSMutableDictionary *jsResponseDict = [NSMutableDictionary dictionary];
    [jsResponseDict hlj_safeSetObject:response.URL.absoluteString forKey:@"url"];
    [jsResponseDict hlj_safeSetObject:response.MIMEType forKey:@"MIMEType"];
    [jsResponseDict hlj_safeSetObject:@(response.expectedContentLength) forKey:@"expectedContentLength"];
    [jsResponseDict hlj_safeSetObject:@(response.statusCode) forKey:@"statusCode"];
    [jsResponseDict hlj_safeSetObject:response.allHeaderFields forKey:@"headers"];
    [jsArguments hlj_safeSetObject:jsResponseDict forKey:@"response"];
    
    // response data string
    [jsArguments hlj_safeSetObject:[HLJJSBoxHttpManager _dictionaryWithJsonString:responseString] forKey:@"data"];
    
    // error
    NSMutableDictionary *jsErrorDict = [NSMutableDictionary dictionary];
    [jsErrorDict hlj_safeSetObject:@(error.code) forKey:@"code"];
    [jsErrorDict hlj_safeSetObject:error.userInfo forKey:@"userInfo"];
    [jsErrorDict hlj_safeSetObject:error.localizedDescription forKey:@"localizedDescription"];
    [jsErrorDict hlj_safeSetObject:error.localizedFailureReason forKey:@"localizedFailureReason"];
    [jsArguments hlj_safeSetObject:jsErrorDict forKey:@"error"];
    
    return [jsArguments copy];
}

+ (NSDictionary *)_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - getters
- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        // reponse
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
        _sessionManager.responseSerializer = responseSerializer;
    }
    return _sessionManager;
}

@end
