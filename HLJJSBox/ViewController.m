//
//  ViewController.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/15.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "ViewController.h"
#import "HLJJSBoxViewController.h"
#import "HLJJSBoxEngine.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "HLJCustomViewController.h"

@interface ViewController ()
@property (nonatomic,strong) AFURLSessionManager *sessionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *aDictionary = @{@"1":@"2",@"2":@"3",@"3":@"4"};
    NSEnumerator *enumerator = [aDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]) != nil) {
        NSLog(@"%@",aDictionary[key]);
    }
}

- (IBAction)click:(UIButton *)sender {
    // request
    HLJCustomViewController *vc = [[HLJCustomViewController alloc] init];
    vc.src = @"http:/127.0.0.1:8080/list.js";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
