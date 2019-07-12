//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVSQLiteConditionModel;

@interface VVConditionModel : NSObject

@property(nonatomic, readonly) VVSQLiteConditionModel *sqlite;

+ (instancetype)condition;

@end