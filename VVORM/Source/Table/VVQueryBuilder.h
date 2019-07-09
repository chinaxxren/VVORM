//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORMClass;
@class VVORMProperty;
@class VVConditionModel;
@class VVNameBuilder;
@class VVSQLiteColumnModel;

@interface VVQueryBuilder : NSObject

+ (NSString *)selectStatement:(VVORMClass *)runtime;

+ (NSString *)selectRowidStatement:(VVORMClass *)runtime;

+ (NSString *)updateStatement:(VVORMClass *)runtime;

+ (NSString *)updateStatement:(VVORMClass *)runtime attributes:(NSArray *)attributes;

+ (NSString *)insertIntoStatement:(VVORMClass *)runtime;

+ (NSString *)insertOrReplaceIntoStatement:(VVORMClass *)runtime;

+ (NSString *)insertOrIgnoreIntoStatement:(VVORMClass *)runtime;

+ (NSString *)deleteFromStatement:(VVORMClass *)runtime;

+ (NSString *)createTableStatement:(VVORMClass *)runtime;

+ (NSString *)dropTableStatement:(VVORMClass *)runtime;

+ (NSString *)createUniqueIndexStatement:(VVORMClass *)runtime;

+ (NSString *)dropIndexStatement:(VVORMClass *)runtime;

+ (NSString *)referencedCountStatement:(VVORMClass *)runtime;

+ (NSString *)countStatement:(VVORMClass *)runtime;

+ (NSString *)uniqueIndexName:(VVORMClass *)runtime;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition runtime:(VVORMClass *)runtime;

+ (NSString *)selectConditionOptionStatement:(VVConditionModel *)condition;

+ (NSString *)deleteConditionStatement:(VVConditionModel *)condition;

+ (NSString *)updateConditionStatement:(VVConditionModel *)condition;

+ (NSString *)rowidConditionStatement;

+ (NSString *)uniqueConditionStatement:(VVORMClass *)runtime;

+ (NSString *)alterTableAddColumnStatement:(NSString *)tableName sqliteColumn:(VVSQLiteColumnModel *)sqliteColumn;

+ (NSString *)maxStatement:(VVORMClass *)runtime columnName:(NSString *)columnName;

+ (NSString *)minStatement:(VVORMClass *)runtime columnName:(NSString *)columnName;

+ (NSString *)avgStatement:(VVORMClass *)runtime columnName:(NSString *)columnName;

+ (NSString *)totalStatement:(VVORMClass *)runtime columnName:(NSString *)columnName;

+ (NSString *)sumStatement:(VVORMClass *)runtime columnName:(NSString *)columnName;


+ (NSString *)createTableStatement:(NSString *)tableName fullTextSearch3:(BOOL)fullTextSearch3 fullTextSearch4:(BOOL)fullTextSearch4 sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)createUniqueIndexStatement:(NSString *)tableName sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)uniqueIndexNameWithTableName:(NSString *)tableName;

@end
