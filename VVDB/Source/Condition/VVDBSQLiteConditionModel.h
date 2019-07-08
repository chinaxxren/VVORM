//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface VVStoreSQLiteConditionModel : NSObject

@property(nonatomic, copy) NSString *where;
@property(nonatomic, strong) NSArray *parameters;
@property(nonatomic, strong) NSString *orderBy;
@property(nonatomic, strong) NSNumber *limit;
@property(nonatomic, strong) NSNumber *offset;

@end

NS_ASSUME_NONNULL_END