//
//  UIList.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIListJSExport <JSExport>

- (void)registerCell:(JSValue*)registerCell;
@property (nonatomic, weak) JSValue *dataSource;
@property (nonatomic, weak) JSValue *isFirstPage;
- (void)beginRefresh;
- (void)endRefresh;

@end

@interface UIList : UIView <UIListJSExport>

@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, strong) NSNumber *headerHeight;
@property (nonatomic, strong) NSNumber *footerHeight;
@property (nonatomic, strong) NSNumber *rowHeight;
- (void)registerCell:(JSValue*)registerCell;
@property (nonatomic, weak) JSValue *dataSource;
@property (nonatomic, weak) JSValue *isFirstPage;

//是否添加下拉刷新
@property (nonatomic, strong) NSNumber *addHeaderRefresh;
//是否添加上拉刷新
@property (nonatomic, strong) NSNumber *addFooterRefresh;
- (void)beginRefresh;
- (void)endRefresh;
- (void)setup;
@end

NS_ASSUME_NONNULL_END
