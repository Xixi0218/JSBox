//
//  HLJCustomViewController.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJCustomViewController.h"
#import "UIView+Yoga.h"
#import "AFNetworking.h"
#import "HLJJSBoxEngine.h"
#import "HLJJSBoxViewController.h"
#import "HLJJSBoxEngine.h"
#import "RACAFNetworking.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import "SVProgressHUD.h"

@interface HLJCustomViewController () <HLJJSBoxEngineDelegate>
@property (nonatomic, strong) HLJJSBoxEngine *jsBox;
@property (nonatomic,strong) AFURLSessionManager *sessionManager;
@end

@implementation HLJCustomViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    RACSignal *mainSignal = [self.sessionManager rac_GET:self.src parameters:nil];
    RACSignal *nextSignal;
    if (self.dependency.count) {
        for (NSString*url in self.dependency) {
            RACSignal *signal = [self.sessionManager rac_GET:url parameters:nil];
            if (nextSignal) {
                nextSignal = [nextSignal zipWith:signal];
            } else {
                nextSignal = signal;
            }
        }
    }
    RACSignal *resultSignal;
    if (nextSignal) {
        resultSignal = [nextSignal zipWith:mainSignal];
    } else {
        resultSignal = mainSignal;
    }
    @weakify(self)
    [resultSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSData class]]) {
            NSString *responseString = [[NSString alloc]initWithData:x encoding:NSUTF8StringEncoding];
            BOOL haveRender = [HLJJSBoxEngine isScriptHaveRender:responseString];
            if (haveRender) {
                [self.jsBox evaluateScript:responseString];
            }
        } else if ([x isKindOfClass:[RACTuple class]]) {
            RACTuple *tuple = x;
            for (id data in tuple.allObjects) {
                if ([data isKindOfClass:NSData.class]) {
                    [self dealJSString:data];
                }
            }
        }
        
    } error:^(NSError * _Nullable error) {
        
    }];
    
    //有时候设置设置了edgesForExtendedLayout会延迟生效
    [self.view layoutIfNeeded];
    [self.navigationController.view setNeedsLayout];
    [self.navigationController.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealJSString:(id)data
{
    NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self.jsBox evaluateScript:responseString];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //刷新布局,这步必须有,要不然在铺满全屏的时候会出现问题
}

#pragma mark - getters
- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        // reponse
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/javascript",nil];
        _sessionManager.responseSerializer = responseSerializer;
    }
    return _sessionManager;
}

- (void)HLJJSBoxPushActionWithUrl:(NSString*)url dependency:(NSArray*)dependency;
{
    HLJCustomViewController *controller = [[HLJCustomViewController alloc] init];
    controller.src = url;
    controller.dependency = dependency;
    controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getters
- (HLJJSBoxEngine *)jsBox {
    if (_jsBox == nil) {
        _jsBox = [[HLJJSBoxEngine alloc] init];
        _jsBox.delegate = self;
        _jsBox.containerView = self.view;
        _jsBox.currentViewController = self;
    }
    return _jsBox;
}


@end
