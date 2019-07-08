//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBConditionModel.h"

#import "VVDBSQLiteConditionModel.h"
#import "VVDBReferenceConditionModel.h"

@interface VVDBConditionModel ()

@property(nonatomic, strong) VVDBSQLiteConditionModel *sqlite;
@property(nonatomic, strong) VVDBReferenceConditionModel *reference;

@end

@implementation VVDBConditionModel

+ (instancetype)condition {
    VVDBConditionModel *condition = [[self alloc] init];
    condition.sqlite = [[VVDBSQLiteConditionModel alloc] init];
    condition.reference = [[VVDBReferenceConditionModel alloc] init];
    return condition;
}

@end