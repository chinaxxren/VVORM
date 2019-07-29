//
// Created by Tank on 2019-07-29.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVCondition.h"

#import "VVSQLiteConditionModel.h"
#import "VVCondition.h"

@implementation VVCondition 

+ (VVCondition *)where:(NSString *)where {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    return condition;
}

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    return condition;
}

+ (VVCondition *)where:(NSString *)where orderBy:(NSString *)orderBy {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.orderBy = orderBy;
    return condition;
}

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    return condition;
}

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters limit:(NSNumber *)limit {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.limit = limit;
    return condition;
}

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    condition.sqlite.limit = limit;
    return condition;
}

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset {
    VVCondition *condition = [VVCondition condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    condition.sqlite.limit = limit;
    condition.sqlite.offset = offset;
    return condition;
}

@end
