//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVConditionModel.h"

#import "VVSQLiteConditionModel.h"

@interface VVConditionModel ()

@property(nonatomic, strong) VVSQLiteConditionModel *sqlite;

@end

@implementation VVConditionModel

+ (instancetype)condition {
    VVConditionModel *condition = [[self alloc] init];
    condition.sqlite = [VVSQLiteConditionModel new];
    return condition;
}

@end