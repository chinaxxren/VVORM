//
// Created by Tank on 2019-07-29.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVCondition.h"

#import "VVSQLiteConditionModel.h"
#import "VVConditionModel.h"

@implementation VVCondition 

+ (VVConditionModel *)where:(NSString *)where {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where orderBy:(NSString *)orderBy {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.orderBy = orderBy;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters limit:(NSNumber *)limit {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.limit = limit;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    condition.sqlite.limit = limit;
    return condition;
}

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    condition.sqlite.limit = limit;
    condition.sqlite.offset = offset;
    return condition;
}

@end
