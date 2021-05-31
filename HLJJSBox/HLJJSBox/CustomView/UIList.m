//
//  UIList.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "UIList.h"
#import <Masonry/Masonry.h>
#import "HLJJSBoxBaseTableViewCell.h"
#import "HLJJSBoxRenderManager.h"
#import "HLJJSBoxDataManager.h"
#import "UIView+mapView.h"
#import "UIView+HLJJSBox.h"
#import "HLJJSBoxEngine.h"
#import "UIView+Yoga.h"
#import "MJRefresh.h"
#import "HLJJSBoxCommonKey.h"

@interface UIList () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary<NSString*,JSManagedValue*> *tableViewCellDict;
@property (nonatomic, strong) HLJJSBoxRenderManager *renderManager;
@property (nonatomic, strong) HLJJSBoxDataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *flexViews;
@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation UIList

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.sectionFooterHeight = 0.01;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setStyle:(UITableViewStyle)style
{
    _style = style;
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.sectionFooterHeight = 0.01;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setup
{
    self.tableView.backgroundColor = self.bgColor;
    if (self.addHeaderRefresh.boolValue) {
        [self addTopRefresh];
    }
    if (self.addFooterRefresh.boolValue) {
        [self addBottomRefresh];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowHeight) {
        NSDictionary *itemData = self.list[indexPath.row];
        if (objc_getAssociatedObject(itemData, @selector(size))) {
            CGFloat height = [objc_getAssociatedObject(itemData, @selector(height)) floatValue];
            return height;
        }
        NSString *identity = itemData[@"identity"];
        HLJJSBoxBaseTableViewCell *cell = self.flexViews[identity];
        [cell updateData:itemData[@"data"]];
        CGFloat height = [cell.contentView.yoga calculateLayoutWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, NAN)].height;
        objc_setAssociatedObject(itemData, @selector(height), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return height;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.headerHeight) {
        return self.headerHeight.floatValue;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.footerHeight) {
        return self.footerHeight.floatValue;
    } else {
        return 0.01;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.list[indexPath.row];
    NSString *identity = itemData[@"identity"];
    HLJJSBoxBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[HLJJSBoxBaseTableViewCell alloc] initWithValue:self.tableViewCellDict[identity]
                                                         engine:self.engine
                                                reuseIdentifier:identity];
        if (itemData[@"selectStyle"]) {
            cell.selectionStyle = [itemData[@"selectStyle"] integerValue];
        }
    }
    [cell updateData:itemData[@"data"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *args = [NSMutableArray arrayWithArray:@[self,@(indexPath.section),@(indexPath.row)]];
    [self.engine callJsFuncWithObj:self eventName:EventDidSelect args:args];
}

#pragma mark - refresh
- (void)addTopRefresh
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf)self = weakSelf;
        if (self.engine) {
            [self.engine callJsFuncWithObj:self eventName:EventHeaderRefresh args:@[self.tableView]];
        }
    }];
}

- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf)self = weakSelf;
        if (self.engine) {
            [self.engine callJsFuncWithObj:self eventName:EventFooterRefresh args:@[self.tableView]];
        }
    }];
}

- (void)beginRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh
{
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    } else if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - set/get
- (void)setDataSource:(JSValue *)dataSource
{
    _dataSource = dataSource;
    JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:dataSource];
    [[self.engine.context virtualMachine] addManagedReference:managedValue withOwner:self];
    if (self.isRefresh) {
        [self.list removeAllObjects];
        [self.flexViews removeAllObjects];
    }
    NSArray *data = [managedValue.value toArray];
    [self.list addObjectsFromArray:data];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *itemData = data[i];
        NSString *identity = itemData[@"identity"];
        if (![self.flexViews valueForKey:identity]) {
            HLJJSBoxBaseTableViewCell *cell = [[HLJJSBoxBaseTableViewCell alloc] initWithValue:self.tableViewCellDict[identity] engine:self.engine reuseIdentifier:identity];
            [cell updateData:itemData[@"data"]];
            [self.flexViews setValue:cell forKey:identity];
        }
    }
    [self.tableView reloadData];
}

- (void)setIsFirstPage:(JSValue *)isFirstPage
{
    _isFirstPage = isFirstPage;
    JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:isFirstPage];
    [[self.engine.context virtualMachine] addManagedReference:managedValue withOwner:self];
    self.isRefresh = [managedValue.value toBool];
}

- (void)registerCell:(JSValue*)registerCell
{
    JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:registerCell];
    [[self.engine.context virtualMachine] addManagedReference:managedValue withOwner:self];
    NSDictionary *dict = [managedValue.value toDictionary];
    NSString *identity = dict[@"identity"];
    self.tableViewCellDict[identity] = managedValue;
}

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (HLJJSBoxRenderManager *)renderManager
{
    if (!_renderManager) {
        _renderManager = [[HLJJSBoxRenderManager alloc] init];
    }
    return _renderManager;
}

- (HLJJSBoxDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [[HLJJSBoxDataManager alloc] init];
    }
    return _dataManager;
}

- (NSMutableDictionary *)tableViewCellDict
{
    if (!_tableViewCellDict) {
        _tableViewCellDict = [NSMutableDictionary dictionary];
    }
    return _tableViewCellDict;
}

- (NSMutableDictionary *)flexViews
{
    if (!_flexViews) {
        _flexViews = [[NSMutableDictionary alloc] init];
    }
    return _flexViews;
}

@end
