//
//  UICollection.h
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/18.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UICollectionJSExport <JSExport>

- (void)registerCell:(JSValue*)registerCell;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSNumber *isFirstPage;
//style不存在,则设置这个也无效
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *contentInset;
@property (nonatomic, strong) NSNumber *ignoredScrollViewContentInsetTop;
- (void)beginRefresh;
- (void)endRefresh;
JSExportAs(setContentOffset, - (void)contentOffset:(NSArray*)point animation:(NSNumber*)animation);
JSExportAs(addSubView, - (void)addSubView:(UIView*)subView point:(NSArray*)point superView:(UIView*)superView);

//提供js使用
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@interface UICollection : UIView <UICollectionJSExport>
//注册cell
- (void)registerCell:(JSValue*)registerCell;
//数据源
@property (nonatomic, strong) NSArray *dataSource;
//设置flowlayout
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
//分页时,用于判断是否是第一页
@property (nonatomic, strong) NSNumber *isFirstPage;
//是否自适应宽度
@property (nonatomic, strong) NSNumber *automaticWidth;
//是否自适应高度
@property (nonatomic, strong) NSNumber *automaticHeight;
/**
 不管是否自适应,都要给
 */
@property (nonatomic, assign) CGSize itemSize;
//是否添加下拉刷新
@property (nonatomic, strong) NSNumber *addHeaderRefresh;
//是否添加上拉刷新
@property (nonatomic, strong) NSNumber *addFooterRefresh;
//开始下拉刷新
- (void)beginRefresh;
//结束刷新刷新
- (void)endRefresh;
//设置刷新
- (void)setup;
//修改contentOffset
- (void)contentOffset:(NSArray*)point animation:(NSNumber*)animation;
- (void)addSubView:(UIView*)subView point:(NSArray*)point superView:(UIView*)superView;
//是否是有选中模式,为bool类型
@property (nonatomic, assign) NSNumber *selectStyle;
//style不存在,则设置这个也无效
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *contentInset;
@property (nonatomic, strong) NSNumber *ignoredScrollViewContentInsetTop;
//提供js使用
@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
