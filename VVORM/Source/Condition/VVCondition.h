//
// Created by Tank on 2019-07-29.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VVConditionModel.h"

@interface VVCondition : VVConditionModel

+ (VVCondition *)where:(NSString *)where;

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters;

+ (VVCondition *)where:(NSString *)where orderBy:(NSString *)orderBy;

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy;

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters limit:(NSNumber *)limit;

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset;

+ (VVCondition *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit;

@end
