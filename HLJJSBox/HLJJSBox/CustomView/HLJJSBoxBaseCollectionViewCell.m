//
//  HLJJSBoxBaseCollectionViewCell.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/18.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxBaseCollectionViewCell.h"
#import "HLJJSBoxRenderManager.h"
#import "HLJJSBoxEngine.h"
#import "UIView+Yoga.h"
#import "HLJJSBoxDataManager.h"
#import "UIView+mapView.h"

@interface HLJJSBoxBaseCollectionViewCell ()
@property (nonatomic, strong) HLJJSBoxRenderManager *renderManager;
@property (nonatomic, strong) HLJJSBoxDataManager *dataManager;
@end

@implementation HLJJSBoxBaseCollectionViewCell

- (instancetype)initWithValue:(JSManagedValue*)managedValue engine:(HLJJSBoxEngine*)engine data:(NSDictionary*)data
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.managedValue = managedValue;
        self.engine = engine;
        self.data = data;
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
        });
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.yoga.isEnabled = YES;
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
}

- (void)updateData:(NSDictionary*)data
{
    [self.dataManager parseData:data superView:self.contentView idMapDict:self.contentView.mapViewDict isAppleLayout:YES];
}

- (void)createUI
{
    [self.renderManager renderUIWithJSRender:self.managedValue.value superView:self.contentView idMapDict:nil engine:self.engine];
    [self updateData:self.data];
    if (self.selectData) {
        [self updateData:self.selectData];
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self updateData:data];
}

- (void)setSelectData:(NSDictionary *)selectData
{
    _selectData = selectData;
    [self updateData:selectData];
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

@end
