//
//  UICollection.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/18.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "UICollection.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIColor+HLJHexColor.h"
#import "HLJJSBoxBaseCollectionViewCell.h"
#import "HLJJSBoxDataManager.h"
#import "UIView+HLJJSBox.h"
#import "HLJJSBoxEngine.h"
#import "HLJJSBoxBaseCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIView+Yoga.h"
#import <objc/runtime.h>
#import "MJRefresh.h"
#import "HLJJSBoxCommonKey.h"
#import "JSValue+judgeNil.h"
#import "UIScrollView+HLJJSBox.h"

@interface UICollection () <CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableDictionary<NSString*,JSManagedValue*> *collectionViewCellDict;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *flexViews;

@end

@implementation UICollection

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
    [self addSubview:self.collectionView];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setup
{
    self.collectionView.backgroundColor = self.bgColor;
    if (self.addHeaderRefresh.boolValue) {
        [self addTopRefresh];
    }
    if (self.addFooterRefresh.boolValue) {
        [self addBottomRefresh];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.automaticWidth.boolValue || self.automaticHeight.boolValue) {
        NSDictionary *itemData = self.list[indexPath.row];
        if (objc_getAssociatedObject(itemData, @selector(size))) {
            CGSize size = [objc_getAssociatedObject(itemData, @selector(size)) CGSizeValue];
            return size;
        }
        NSString *identity = itemData[@"identity"];
        HLJJSBoxBaseCollectionViewCell *cell = self.flexViews[identity];
        [cell updateData:itemData[@"data"]];
        CGSize size;
        if ([self.flowLayout isKindOfClass:CHTCollectionViewWaterfallLayout.class]) {
            CHTCollectionViewWaterfallLayout *flowLayout = (CHTCollectionViewWaterfallLayout*)self.flowLayout;
            size = [cell.contentView.yoga calculateLayoutWithSize:CGSizeMake((UIScreen.mainScreen.bounds.size.width-flowLayout.sectionInset.left-flowLayout.sectionInset.right)/flowLayout.columnCount, NAN)];
        } else {
            if (self.automaticWidth.boolValue) {
                size = [cell.contentView.yoga calculateLayoutWithSize:CGSizeMake(NAN, self.itemSize.height)];
            } else {
                size = [cell.contentView.yoga calculateLayoutWithSize:CGSizeMake(self.itemSize.width, NAN)];
            }
        }
        objc_setAssociatedObject(itemData, @selector(size), @(size), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return size;
    } else {
        return self.itemSize;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = self.list[indexPath.item];
    NSString *identity = itemData[@"identity"];
    HLJJSBoxBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    cell.managedValue = self.collectionViewCellDict[identity];
    cell.engine = self.engine;
    cell.data = itemData[@"data"];
    if (self.selectStyle.boolValue) {
        if (self.selectIndex == indexPath.row) {
            JSManagedValue *managedValue = self.collectionViewCellDict[identity];
            NSDictionary *selectData = [managedValue.value toDictionary][@"select"];
            cell.selectData = selectData;
        } else {
            JSManagedValue *managedValue = self.collectionViewCellDict[identity];
            NSDictionary *normalData = [managedValue.value toDictionary][@"normal"];
            cell.selectData = normalData;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *args = [NSMutableArray arrayWithArray:@[self,@(indexPath.section),@(indexPath.row)]];
    [self.engine callJsFuncWithObj:self eventName:EventDidSelect args:args];
}

#pragma mark - refresh
- (void)addTopRefresh
{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf)self = weakSelf;
        if (self.engine) {
            [self.engine callJsFuncWithObj:self eventName:EventHeaderRefresh args:@[self.collectionView]];
        }
    }];
}

- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf)self = weakSelf;
        if (self.engine) {
            [self.engine callJsFuncWithObj:self eventName:EventFooterRefresh args:@[self.collectionView]];
        }
    }];
}

- (void)beginRefresh
{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)endRefresh
{
    if (self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    } else if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self.engine getJsValueWithObject:self name:EventScrollViewDidScroll].isNil) {
        [self.engine callJsFuncWithObj:self eventName:EventScrollViewDidScroll args:@[self.collectionView]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (![self.engine getJsValueWithObject:self name:EventScrollViewWillBeginDragging].isNil) {
        [self.engine callJsFuncWithObj:self eventName:EventScrollViewWillBeginDragging args:@[self.collectionView]];
    }
}

#pragma mark - method
- (void)contentOffset:(NSArray*)point animation:(NSNumber*)animation
{
    if (!point && point.count != 2) {
        return;
    }
    [self.collectionView setContentOffset:CGPointMake([point[0] floatValue], [point[1] floatValue]) animated:animation.boolValue];
}

- (void)registerCell:(JSValue *)registerCell
{
    JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:registerCell];
    [[self.engine.context virtualMachine] addManagedReference:managedValue withOwner:self];
    NSDictionary *dict = [managedValue.value toDictionary];
    NSString *identity = dict[@"identity"];
    self.collectionViewCellDict[identity] = managedValue;
    [self.collectionView registerClass:HLJJSBoxBaseCollectionViewCell.class forCellWithReuseIdentifier:identity];
}

- (void)addSubView:(UIView*)subView point:(NSArray*)point superView:(UIView*)superView
{
    [superView addSubview:subView];
    if (!point && point.count != 2) {
        return;
    }
    CGRect rect = subView.frame;
    rect.origin = CGPointMake([point[0] floatValue], [point[1] floatValue]);
    subView.frame = rect;
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showHorizontalIndicator = NO;
        _collectionView.showVerticalIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F2F3F6"];
    }
    return _collectionView;
}

- (void)setContentInset:(NSArray *)contentInset
{
    if (!contentInset && contentInset.count != 4) {
        return;
    }
    self.collectionView.contentInset = UIEdgeInsetsMake([contentInset[0] floatValue], [contentInset[1] floatValue], [contentInset[2] floatValue], [contentInset[3] floatValue]);
}

- (void)setIgnoredScrollViewContentInsetTop:(NSNumber *)ignoredScrollViewContentInsetTop
{
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = [ignoredScrollViewContentInsetTop floatValue];
}

- (void)setFlowLayout:(UICollectionViewFlowLayout *)flowLayout
{
    _flowLayout = flowLayout;
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (self.selectStyle.boolValue) {
        [self.collectionView reloadData];
    }
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    if (self.addHeaderRefresh.boolValue || self.addFooterRefresh.boolValue) {
        if (self.isFirstPage.boolValue) {
            [self.list removeAllObjects];
        }
    } else {
        [self.list removeAllObjects];
    }
    
    NSMutableArray *insertIndexPath = [NSMutableArray array];
    for (int i = 0; i < dataSource.count; i++) {
        NSDictionary *itemData = dataSource[i];
        NSString *identity = itemData[@"identity"];
        if (![self.flexViews valueForKey:identity]) {
            HLJJSBoxBaseCollectionViewCell *cell = [[HLJJSBoxBaseCollectionViewCell alloc] initWithValue:self.collectionViewCellDict[identity] engine:self.engine data:itemData[@"data"]];
            [self.flexViews setValue:cell forKey:identity];
        }
        [insertIndexPath addObject:[NSIndexPath indexPathForRow:self.list.count+i inSection:0]];
    }
    [self.list addObjectsFromArray:dataSource];
    if (self.addHeaderRefresh.boolValue || self.addFooterRefresh.boolValue) {
        if (self.isFirstPage.boolValue) {
            [self.collectionView reloadData];
        } else {
            [self.collectionView insertItemsAtIndexPaths:insertIndexPath];
        }
    } else {
        [self.collectionView reloadData];
    }
}

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (NSMutableDictionary *)collectionViewCellDict
{
    if (!_collectionViewCellDict) {
        _collectionViewCellDict = [NSMutableDictionary dictionary];
    }
    return _collectionViewCellDict;
}

- (NSMutableDictionary *)flexViews
{
    if (!_flexViews) {
        _flexViews = [[NSMutableDictionary alloc] init];
    }
    return _flexViews;
}

@end
