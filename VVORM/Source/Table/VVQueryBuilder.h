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

+ (NSString *)selectStatement:(VVORMClass *)ormClass;

+ (NSString *)selectRowidStatement:(VVORMClass *)ormClass;

+ (NSString *)updateStatement:(VVORMClass *)ormClass;

+ (NSString *)updateStatement:(VVORMClass *)ormClass attributes:(NSArray *)attributes;

+ (NSString *)insertIntoStatement:(VVORMClass *)ormClass;

+ (NSString *)insertOrReplaceIntoStatement:(VVORMClass *)ormClass;

+ (NSString *)insertOrIgnoreIntoStatement:(VVORMClass *)ormClass;

+ (NSString *)deleteFromStatement:(VVORMClass *)ormClass;

+ (NSString *)createTableStatement:(VVORMClass *)ormClass;

+ (NSString *)dropTableStatement:(VVORMClass *)ormClass;

+ (NSString *)createUniqueIndexStatement:(VVORMClass *)ormClass;

+ (NSString *)dropIndexStatement:(VVORMClass *)ormClass;

+ (NSString *)referencedCountStatement:(VVORMClass *)ormClass;

+ (NSString *)countStatement:(VVORMClass *)ormClass;

+ (NSString *)uniqueIndexName:(VVORMClass *)ormClass;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition;

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition ormClass:(VVORMClass *)ormClass;

+ (NSString *)selectConditionOptionStatement:(VVConditionModel *)condition;

+ (NSString *)deleteConditionStatement:(VVConditionModel *)condition;

+ (NSString *)updateConditionStatement:(VVConditionModel *)condition;

+ (NSString *)rowidConditionStatement;

+ (NSString *)uniqueConditionStatement:(VVORMClass *)ormClass;

+ (NSString *)alterTableAddColumnStatement:(NSString *)tableName sqliteColumn:(VVSQLiteColumnModel *)sqliteColumn;

+ (NSString *)maxStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName;

+ (NSString *)minStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName;

+ (NSString *)avgStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName;

+ (NSString *)totalStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName;

+ (NSString *)sumStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName;


+ (NSString *)createTableStatement:(NSString *)tableName fullTextSearch3:(BOOL)fullTextSearch3 fullTextSearch4:(BOOL)fullTextSearch4 sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)createUniqueIndexStatement:(NSString *)tableName sqliteColumns:(NSArray *)sqliteColumns;

+ (NSString *)uniqueIndexNameWithTableName:(NSString *)tableName;

@end
