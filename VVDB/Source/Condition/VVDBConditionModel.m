//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVStoreConditionModel.h"

#import "VVStoreSQLiteConditionModel.h"
#import "VVStoreReferenceConditionModel.h"

@interface VVStoreConditionModel ()

@property(nonatomic, strong) VVStoreSQLiteConditionModel *sqlite;
@property(nonatomic, strong) VVStoreReferenceConditionModel *reference;

@end

@implementation VVStoreConditionModel

+ (instancetype)condition {
    VVStoreConditionModel *condition = [[self alloc] init];
    condition.sqlite = [[VVStoreSQLiteConditionModel alloc] init];
    condition.reference = [[VVStoreReferenceConditionModel alloc] init];
    return condition;
}

@end