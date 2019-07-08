//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVDBRuntime;
@class VVDBRuntimeProperty;
@class VVDBConditionModel;
@class VVDBNameBuilder;
@class VVDBSQLiteColumnModel;

@interface VVDBQueryBuilder : NSObject

+ (NSString *)selectStatement:(VVDBRuntime *)runtime;

+ (NSString *)selectRowidStatement:(VVDBRuntime *)runtime;

+ (NSString *)updateStatement:(VVDBRuntime *)runtime;

+ (NSString *)updateStatement:(VVDBRuntime *)runtime attributes:(NSArray *)attributes;

+ (NSString *)insertIntoStatement:(VVDBRuntime *)runtime;

+ (NSString *)insertOrReplaceIntoStatement:(VVDBRuntime *)runtime;

+ (NSString *)insertOrIgnoreIntoStatement:(VVDBRuntime *)runtime;

+ (NSString *)deleteFromStatement:(VVDBRuntime *)runtime;

+ (NSString *)createTableStatement:(VVDBRuntime *)runtime;

+ (NSString *)dropTableStatement:(VVDBRuntime *)runtime;

+ (NSString *)createUniqueIndexStatement:(VVDBRuntime *)runtime;

+ (NSString *)dropIndexStatement:(VVDBRuntime *)runtime;

+ (NSString *)referencedCountStatement:(VVDBRuntime *)runtime;

+ (NSString *)countStatement:(VVDBRuntime *)runtime;

+ (NSString *)uniqueIndexName:(VVDBRuntime *)runtime;

+ (NSString *)selectConditionStatement:(VVDBConditionModel *)condition;

+ (NSString *)selectConditionStatement:(VVDBConditionModel *)condition runtime:(VVDBRuntime *)runtime;

+ (NSString *)selectConditionOptionStatement:(VVDBConditionModel *)condition;

+ (NSString *)deleteConditionStatement:(VVDBConditionModel *)condition;

+ (NSString *)updateConditionStatement:(VVDBConditionModel *)condition;

+ (NSString *)rowidConditionStatement;

+ (NSString *)uniqueConditionStatement:(VVDBRuntime *)runtime;

+ (NSString *)alterTableAddColumnStatement:(NSString *)tableName sqliteColumn:(VVDBSQLiteColumnModel *)sqliteColumn;

+ (NSString *)maxStatement:(VVDBRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)minStatement:(VVDBRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)avgStatement:(VVDBRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)totalStatement:(VVDBRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)sumStatement:(VVDBRuntime *)runtime columnName:(NSString *)columnName;


+ (NSString *)createTableStatement:(NSString *)tableName fullTextSearch3:(BOOL)fullTextSearch3 fullTextSearch4:(BOOL)fullTextSearch4 sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)createUniqueIndexStatement:(NSString *)tableName sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)uniqueIndexNameWithTableName:(NSString *)tableName;

@end
