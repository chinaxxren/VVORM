//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVDBSQLiteConditionModel;
@class VVDBReferenceConditionModel;


@interface VVDBConditionModel : NSObject

@property(nonatomic, readonly) VVDBSQLiteConditionModel *sqlite;
@property(nonatomic, readonly) VVDBReferenceConditionModel *reference;

+ (instancetype)condition;

@end