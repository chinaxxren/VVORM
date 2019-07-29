//
// Created by Tank on 2019-07-29.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVConditionModel;

@interface VVCondition : NSObject

+ (VVConditionModel *)where:(NSString *)where;

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters;

+ (VVConditionModel *)where:(NSString *)where orderBy:(NSString *)orderBy;

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy;

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters limit:(NSNumber *)limit;

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit offset:(NSNumber *)offset;

+ (VVConditionModel *)where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy limit:(NSNumber *)limit;

@end
