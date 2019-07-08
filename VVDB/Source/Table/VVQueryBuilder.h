//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVRuntime;
@class VVRuntimeProperty;
@class VVConditionModel;
@class VVNameBuilder;
@class VVSQLiteColumnModel;

@interface VVQueryBuilder : NSObject

+ (NSString *)selectStatement:(VVRuntime *)runtime;

+ (NSString *)selectRowidStatement:(VVRuntime *)runtime;

+ (NSString *)updateStatement:(VVRuntime *)runtime;

+ (NSString *)updateStatement:(VVRuntime *)runtime attributes:(NSArray *)attributes;

+ (NSString *)insertIntoStatement:(VVRuntime *)runtime;

+ (NSString *)insertOrReplaceIntoStatement:(VVRuntime *)runtime;

+ (NSString *)insertOrIgnoreIntoStatement:(VVRuntime *)runtime;

+ (NSString *)deleteFromStatement:(VVRuntime *)runtime;

+ (NSString *)createTableStatement:(VVRuntime *)runtime;

+ (NSString *)dropTableStatement:(VVRuntime *)runtime;

+ (NSString *)createUniqueIndexStatement:(VVRuntime *)runtime;

+ (NSString *)dropIndexStatement:(VVRuntime *)runtime;

+ (NSString *)referencedCountStatement:(VVRuntime *)runtime;

+ (NSString *)countStatement:(VVRuntime *)runtime;

+ (NSString *)uniqueIndexName:(VVRuntime *)runtime;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition runtime:(VVRuntime *)runtime;

+ (NSString *)selectConditionOptionStatement:(VVConditionModel *)condition;

+ (NSString *)deleteConditionStatement:(VVConditionModel *)condition;

+ (NSString *)updateConditionStatement:(VVConditionModel *)condition;

+ (NSString *)rowidConditionStatement;

+ (NSString *)uniqueConditionStatement:(VVRuntime *)runtime;

+ (NSString *)alterTableAddColumnStatement:(NSString *)tableName sqliteColumn:(VVSQLiteColumnModel *)sqliteColumn;

+ (NSString *)maxStatement:(VVRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)minStatement:(VVRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)avgStatement:(VVRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)totalStatement:(VVRuntime *)runtime columnName:(NSString *)columnName;

+ (NSString *)sumStatement:(VVRuntime *)runtime columnName:(NSString *)columnName;


+ (NSString *)createTableStatement:(NSString *)tableName fullTextSearch3:(BOOL)fullTextSearch3 fullTextSearch4:(BOOL)fullTextSearch4 sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)createUniqueIndexStatement:(NSString *)tableName sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)uniqueIndexNameWithTableName:(NSString *)tableName;

@end
