//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVQueryBuilder.h"

#import "VVORMClass.h"
#import "VVORMProperty.h"
#import "VVConditionModel.h"
#import "VVSQLiteColumnModel.h"
#import "VVSQLiteConditionModel.h"
#import "VVReferenceConditionModel.h"
#import "NSObject+VVTabel.h"

@implementation VVQueryBuilder

#pragma mark per ormClass

+ (NSArray *)sqliteColumnsWithAttributes:(NSArray *)attributes {
    NSMutableArray *sqliteColumns = [NSMutableArray array];
    for (VVORMProperty *attribute in attributes) {
        [sqliteColumns addObjectsFromArray:attribute.sqliteColumns];
    }
    return sqliteColumns;
}

+ (NSString *)selectStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT "];
    NSArray *attributes = ormClass.attributes;
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sql appendString:@""];
        [sql appendString:sqliteColumn.columnName];
        [sql appendString:@""];
        if ([sqliteColumns lastObject] != sqliteColumn) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@" FROM "];
    [sql appendString:@""];
    [sql appendString:tableName];
    [sql appendString:@""];
    return [NSString stringWithString:sql];
}

+ (NSString *)selectRowidStatement:(VVORMClass *)ormClass {
    VVSQLiteColumnModel *sqliteColumn = ormClass.rowidAttribute.sqliteColumns.firstObject;
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT "];
    [sql appendString:@""];
    [sql appendString:sqliteColumn.columnName];
    [sql appendString:@""];
    [sql appendString:@" FROM "];
    [sql appendString:@""];
    [sql appendString:tableName];
    [sql appendString:@""];
    return [NSString stringWithString:sql];
}

+ (NSString *)updateStatement:(VVORMClass *)ormClass {
    return [self updateStatement:ormClass attributes:ormClass.updateAttributes];
}

+ (NSString *)updateStatement:(VVORMClass *)ormClass attributes:(NSArray *)attributes {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"UPDATE "];
    [sql appendString:tableName];
    [sql appendString:@" SET "];
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sql appendString:@""];
        [sql appendString:sqliteColumn.columnName];
        [sql appendString:@""];
        [sql appendString:@" = ?"];
        [sql appendString:@","];
    }
    [sql appendString:@"__updated_at__ = datetime('now')"];
    return [NSString stringWithString:sql];
}

+ (NSString *)insertIntoStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:tableName];
    NSMutableString *sqlNames = [NSMutableString stringWithFormat:@" ("];
    NSMutableString *sqlValues = [NSMutableString stringWithFormat:@" ("];
    NSArray *attributes = ormClass.insertAttributes;
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sqlNames appendString:@""];
        [sqlNames appendString:sqliteColumn.columnName];
        [sqlNames appendString:@""];
        [sqlValues appendString:@"?"];
        [sqlNames appendString:@","];
        [sqlValues appendString:@","];
    }
    [sqlNames appendString:@"__created_at__"];
    [sqlNames appendString:@",__updated_at__"];
    [sqlValues appendString:@"datetime('now')"];
    [sqlValues appendString:@",datetime('now')"];
    [sqlNames appendString:@")"];
    [sqlValues appendString:@")"];
    [sql appendString:sqlNames];
    [sql appendString:@" VALUES "];
    [sql appendString:sqlValues];
    return [NSString stringWithString:sql];
}

+ (NSString *)insertOrReplaceIntoStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"INSERT OR REPLACE INTO "];
    [sql appendString:tableName];
    NSMutableString *sqlNames = [NSMutableString stringWithFormat:@" ("];
    NSMutableString *sqlValues = [NSMutableString stringWithFormat:@" ("];
    NSArray *attributes = ormClass.attributes;
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sqlNames appendString:@""];
        [sqlNames appendString:sqliteColumn.columnName];
        [sqlNames appendString:@""];
        [sqlValues appendString:@"?"];
        [sqlNames appendString:@","];
        [sqlValues appendString:@","];
    }
    [sqlNames appendString:@"__created_at__"];
    [sqlNames appendString:@",__updated_at__"];
    [sqlValues appendString:@"datetime('now')"];
    [sqlValues appendString:@",datetime('now')"];
    [sqlNames appendString:@")"];
    [sqlValues appendString:@")"];
    [sql appendString:sqlNames];
    [sql appendString:@" VALUES "];
    [sql appendString:sqlValues];
    return [NSString stringWithString:sql];
}

+ (NSString *)insertOrIgnoreIntoStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"INSERT OR IGNORE INTO "];
    [sql appendString:tableName];
    NSMutableString *sqlNames = [NSMutableString stringWithFormat:@" ("];
    NSMutableString *sqlValues = [NSMutableString stringWithFormat:@" ("];
    NSArray *attributes = ormClass.insertAttributes;
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sqlNames appendString:@""];
        [sqlNames appendString:sqliteColumn.columnName];
        [sqlNames appendString:@""];
        [sqlValues appendString:@"?"];
        [sqlNames appendString:@","];
        [sqlValues appendString:@","];
    }
    [sqlNames appendString:@"__created_at__"];
    [sqlNames appendString:@",__updated_at__"];
    [sqlValues appendString:@"datetime('now')"];
    [sqlValues appendString:@",datetime('now')"];
    [sqlNames appendString:@")"];
    [sqlValues appendString:@")"];
    [sql appendString:sqlNames];
    [sql appendString:@" VALUES "];
    [sql appendString:sqlValues];
    return [NSString stringWithString:sql];
}

+ (NSString *)deleteFromStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)createTableStatement:(VVORMClass *)ormClass {
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:ormClass.insertAttributes];
    return [self createTableStatement:ormClass.tableName fullTextSearch3:ormClass.fullTextSearch3 fullTextSearch4:ormClass.fullTextSearch4 sqliteColumns:sqliteColumns];
}

+ (NSString *)createTableStatement:(NSString *)tableName fullTextSearch3:(BOOL)fullTextSearch3 fullTextSearch4:(BOOL)fullTextSearch4 sqliteColumns:(NSArray *)sqliteColumns {
    NSMutableString *sql = [NSMutableString string];
    if (fullTextSearch3 || fullTextSearch4) {
        [sql appendString:@"CREATE VIRTUAL TABLE IF NOT EXISTS "];
    } else {
        [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    }
    [sql appendString:tableName];
    if (fullTextSearch3) {
        [sql appendString:@" USING fts3 "];
    } else if (fullTextSearch4) {
        [sql appendString:@" USING fts4 "];
    }
    [sql appendString:@" ("];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sql appendString:sqliteColumn.columnName];
        [sql appendString:@" "];
        [sql appendString:sqliteColumn.dataTypeName];
        [sql appendString:@","];
    }
    [sql appendString:@"__created_at__ "];
    [sql appendString:@"DATE"];
    [sql appendString:@",__updated_at__ "];
    [sql appendString:@"DATE"];
    [sql appendString:@")"];
    return [NSString stringWithString:sql];
}

+ (NSString *)dropTableStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"DROP TABLE "];
    [sql appendString:tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)uniqueIndexName:(VVORMClass *)ormClass {
    return [self uniqueIndexNameWithTableName:ormClass.tableName];
}

+ (NSString *)uniqueIndexNameWithTableName:(NSString *)tableName {
    return [NSString stringWithFormat:@"%@_IDX", tableName];
}

+ (NSString *)createUniqueIndexStatement:(VVORMClass *)ormClass {
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:ormClass.identificationAttributes];
    return [self createUniqueIndexStatement:ormClass.tableName sqliteColumns:sqliteColumns];
}

+ (NSString *)createUniqueIndexStatement:(NSString *)tableName sqliteColumns:(NSArray *)sqliteColumns {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"CREATE "];
    [sql appendString:@"UNIQUE "];
    [sql appendString:@"INDEX "];
    [sql appendString:[self uniqueIndexNameWithTableName:tableName]];
    [sql appendString:@" ON "];
    [sql appendString:tableName];
    [sql appendString:@" ("];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sql appendString:sqliteColumn.columnName];
        if (sqliteColumns.lastObject != sqliteColumn) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    return sql;
}

+ (NSString *)dropIndexStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"DROP INDEX IF EXISTS "];
    [sql appendString:tableName];
    [sql appendString:@"_IDX"];
    return [NSString stringWithString:sql];
}

+ (NSString *)referencedCountStatement:(VVORMClass *)ormClass {
    NSString *tableName = @"__VVORMRelationship__";
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT COUNT(*) FROM ("];
    [sql appendString:@"SELECT DISTINCT fromTableName,fromRowid FROM "];
    [sql appendString:tableName];
    [sql appendString:@"%@ "];
    [sql appendString:@") TBL "];
    return [NSString stringWithString:sql];
}

+ (NSString *)countStatement:(VVORMClass *)ormClass {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT COUNT(*) FROM "];
    [sql appendString:tableName];
    [sql appendString:@""];
    return [NSString stringWithString:sql];
}


#pragma mark per attribute

+ (NSString *)alterTableAddColumnStatement:(NSString *)tableName sqliteColumn:(VVSQLiteColumnModel *)sqliteColumn {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"ALTER TABLE "];
    [sql appendString:tableName];
    [sql appendString:@" ADD COLUMN "];
    [sql appendString:sqliteColumn.columnName];
    [sql appendString:@" "];
    [sql appendString:sqliteColumn.dataTypeName];
    return [NSString stringWithString:sql];
}

+ (NSString *)maxStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT MAX(%@) %@ FROM %@", columnName, columnName, tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)minStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT MIN(%@) %@ FROM %@", columnName, columnName, tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)avgStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT AVG(%@) %@ FROM %@", columnName, columnName, tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)totalStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT TOTAL(%@) %@ FROM %@", columnName, columnName, tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)sumStatement:(VVORMClass *)ormClass columnName:(NSString *)columnName {
    NSString *tableName = ormClass.tableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT SUM(%@) %@ FROM %@", columnName, columnName, tableName];
    return [NSString stringWithString:sql];
}

#pragma mark unique condition

+ (NSString *)rowidConditionStatement {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"rowid = ?"];
    return [NSString stringWithString:sql];
}

+ (NSString *)uniqueConditionStatement:(VVORMClass *)ormClass {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@""];
    NSArray *attributes = ormClass.identificationAttributes;
    NSArray *sqliteColumns = [self sqliteColumnsWithAttributes:attributes];
    for (VVSQLiteColumnModel *sqliteColumn in sqliteColumns) {
        [sql appendString:sqliteColumn.columnName];
        [sql appendString:@" = ?"];
        if (sqliteColumn != sqliteColumns.lastObject) {
            [sql appendString:@" AND "];
        }
    }
    return [NSString stringWithString:sql];
}


#pragma mark condition

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@" where "];
    if (condition.sqlite.where) {
        [sql appendString:@" ("];
        [sql appendString:condition.sqlite.where];
        [sql appendString:@" )"];
    }
    return [NSString stringWithString:sql];
}

+ (NSString *)deleteConditionStatement:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@" where "];
    if (condition.sqlite.where) {
        [sql appendString:@" ("];
        [sql appendString:condition.sqlite.where];
        [sql appendString:@" )"];
    }
    return [NSString stringWithString:sql];
}

+ (NSString *)updateConditionStatement:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@" where "];
    if (condition.sqlite.where) {
        [sql appendString:@" ("];
        [sql appendString:condition.sqlite.where];
        [sql appendString:@" )"];
    }
    return [NSString stringWithString:sql];
}

+ (NSString *)selectConditionStatement:(VVConditionModel *)condition ormClass:(VVORMClass *)ormClass {
    NSMutableString *sql = [NSMutableString string];
    if (condition.sqlite.where || condition.reference.from || condition.reference.to) {
        BOOL firstCondition = YES;
        [sql appendString:@" where "];
        if (condition.sqlite.where) {
            [sql appendString:@" ("];
            [sql appendString:condition.sqlite.where];
            [sql appendString:@" )"];
            firstCondition = NO;
        }
        if (condition.reference.from) {
            if (!firstCondition) {
                [sql appendString:@" AND "];
                firstCondition = NO;
            }
            NSString *relationshipTableName = @"__VVORMRelationship__";
            NSString *toTableName = ormClass.tableName;
            NSString *fromTableName = condition.reference.from.VVRuntime.tableName;
            NSString *fromRowid = [condition.reference.from.rowid stringValue];
            if ([NSNull null] == condition.reference.from) {
                [sql appendString:[NSString stringWithFormat:@" NOT EXISTS (SELECT * FROM %@ r1 WHERE r1.toRowid = %@.rowid AND r1.toTableName = '%@' )", relationshipTableName, toTableName, toTableName]];
            } else {
                [sql appendString:[NSString stringWithFormat:@" EXISTS (SELECT * FROM %@ r1 WHERE r1.fromTableName = '%@' and r1.fromRowid = %@ and r1.toRowid = %@.rowid AND r1.toTableName = '%@' )", relationshipTableName, fromTableName, fromRowid, toTableName, toTableName]];
            }
        }
        if (condition.reference.to) {
            if (!firstCondition) {
                [sql appendString:@" AND "];
            }
            NSString *relationshipTableName = @"__VVORMRelationship__";
            NSString *fromTableName = ormClass.tableName;
            NSString *toTableName = condition.reference.to.VVRuntime.tableName;;
            NSString *toRowid = [condition.reference.to.rowid stringValue];
            if ([NSNull null] == condition.reference.to) {
                [sql appendString:[NSString stringWithFormat:@" NOT EXISTS (SELECT * FROM %@ r1 WHERE r1.fromRowid = %@.rowid AND r1.fromTableName = '%@' )", relationshipTableName, fromTableName, fromTableName]];
            } else {
                [sql appendString:[NSString stringWithFormat:@" EXISTS (SELECT * FROM %@ r1 WHERE r1.toTableName = '%@' and r1.toRowid = %@ and r1.fromRowid = %@.rowid AND r1.fromTableName = '%@' )", relationshipTableName, toTableName, toRowid, fromTableName, fromTableName]];
            }
        }
    }
    return [NSString stringWithString:sql];
}

+ (NSString *)selectConditionOptionStatement:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    if (condition.sqlite.orderBy) {
        [sql appendString:@" order by "];
        [sql appendString:condition.sqlite.orderBy];
        [sql appendString:@" "];
    }
    if (condition.sqlite.limit) {
        [sql appendString:@" limit "];
        [sql appendString:[condition.sqlite.limit stringValue]];
        [sql appendString:@" "];
    }
    if (condition.sqlite.offset) {
        [sql appendString:@" offset "];
        [sql appendString:[condition.sqlite.offset stringValue]];
        [sql appendString:@" "];
    }
    return [NSString stringWithString:sql];
}

@end
