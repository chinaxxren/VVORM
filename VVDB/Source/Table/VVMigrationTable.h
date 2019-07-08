//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVDBMigrationTable : NSObject

@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, copy) NSString *tableName;
@property(nonatomic, copy) NSString *temporaryTableName;
@property(nonatomic, assign) BOOL fullTextSearch3;
@property(nonatomic, assign) BOOL fullTextSearch4;
@property(nonatomic, strong) NSMutableDictionary *attributes;
@property(nonatomic, strong) NSMutableDictionary *migrateAttributes;
@property(nonatomic, strong) NSMutableDictionary *identicalAttributes;
@property(nonatomic, strong) NSMutableDictionary *previousTables;

@end

NS_ASSUME_NONNULL_END