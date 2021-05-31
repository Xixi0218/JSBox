//
//  AFURLSessionManager+RACSupport.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/26.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "AFURLSessionManager+RACSupport.h"
#import "HLJJSBoxCommonKey.h"

@implementation AFURLSessionManager (RACSupport)

- (RACSignal *)rac_GET:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"GET"]
            
            setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"HEAD"]
            setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"POST"]
            setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
            setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
            setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id _Nullable)parameters {
    return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
            setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id _Nullable)parameters method:(NSString *)method {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:path parameters:parameters error:nil];
        request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
                [subscriber sendError:errorWithRes];
            } else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
