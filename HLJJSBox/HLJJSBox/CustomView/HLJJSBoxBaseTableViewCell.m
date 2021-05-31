//
//  HLJJSBoxBaseTableViewCell.m
//  HLJJSBox
//
//  Created by Ye Keyon on 2020/4/17.
//  Copyright © 2020 KeyonYe. All rights reserved.
//

#import "HLJJSBoxBaseTableViewCell.h"
#import "UIView+Yoga.h"
#import "HLJJSBoxDataManager.h"
#import "HLJJSBoxRenderManager.h"
#import "UIView+mapView.h"
#import "HLJJSBoxEngine.h"

@interface HLJJSBoxBaseTableViewCell ()
@property (nonatomic, strong) HLJJSBoxRenderManager *renderManager;
@property (nonatomic, strong) HLJJSBoxDataManager *dataManager;
@property (nonatomic, strong) JSManagedValue *managedValue;
@property (nonatomic, weak) HLJJSBoxEngine *engine;
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation HLJJSBoxBaseTableViewCell

- (instancetype)initWithValue:(JSManagedValue*)managedValue engine:(HLJJSBoxEngine*)engine reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.managedValue = managedValue;
        self.engine = engine;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self.renderManager renderUIWithJSRender:self.managedValue.value superView:self.contentView idMapDict:nil engine:self.engine];
}

- (void)updateData:(NSDictionary*)data
{
    [self.dataManager parseData:data superView:self.contentView idMapDict:self.contentView.mapViewDict isAppleLayout:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.yoga.isEnabled = YES;
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
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
