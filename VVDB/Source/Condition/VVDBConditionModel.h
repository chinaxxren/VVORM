//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVStoreSQLiteConditionModel;
@class VVStoreReferenceConditionModel;


@interface VVStoreConditionModel : NSObject

@property(nonatomic, readonly) VVStoreSQLiteConditionModel *sqlite;
@property(nonatomic, readonly) VVStoreReferenceConditionModel *reference;

+ (instancetype)condition;

@end