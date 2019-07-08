//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBMigrationQueryBuilder.h"
#import "VVMigrationTable.h"


#import "VVSQLiteColumnModel.h"

#import "VVQueryBuilder.h"
#import "VVMigrationRuntimeProperty.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBMigrationQueryBuilder

#pragma mark migration

+ (NSString *)updateRelationshipFromTableName:(NSString *)tableName clazzName:(NSString *)clazzName {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"UPDATE __ObjectStoreRelationship__ SET fromTableName = "];
    [sql appendString:@"'"];
    [sql appendString:tableName];
    [sql appendString:@"'"];
    [sql appendString:@" WHERE fromClassName = "];
    [sql appendString:@"'"];
    [sql appendString:clazzName];
    [sql appendString:@"'"];
    return [NSString stringWithString:sql];
}

+ (NSString *)updateRelationshipToTableName:(NSString *)tableName clazzName:(NSString *)clazzName {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"UPDATE __ObjectStoreRelationship__ SET toTableName = "];
    [sql appendString:@"'"];
    [sql appendString:tableName];
    [sql appendString:@"'"];
    [sql appendString:@"WHERE toClassName = "];
    [sql appendString:@"'"];
    [sql appendString:clazzName];
    [sql appendString:@"'"];
    return [NSString stringWithString:sql];
}

+ (NSString *)selectInsertStatementWithToMigrationTable:(VVMigrationTable *)toMigrationTable fromMigrationTable:(VVMigrationTable *)fromMigrationTable {
    NSMutableString *sqlInsert = [NSMutableString string];
    [sqlInsert appendString:@"INSERT INTO "];
    [sqlInsert appendString:toMigrationTable.temporaryTableName];
    [sqlInsert appendString:@"("];
    for (VVMigrationRuntimeProperty *attribute in fromMigrationTable.migrateAttributes.allValues) {
        for (VVSQLiteColumnModel *sqliteColumn in attribute.latestAttbiute.sqliteColumns) {
            [sqlInsert appendString:sqliteColumn.columnName];
            [sqlInsert appendString:@","];
        }
    }
    [sqlInsert appendString:@"__createdAt__"];
    [sqlInsert appendString:@",__updatedAt__"];
    [sqlInsert appendString:@")"];
    NSMutableString *sqlSelect = [NSMutableString string];
    [sqlSelect appendString:@" "];
    [sqlSelect appendString:@"SELECT "];
    for (VVMigrationRuntimeProperty *attribute in fromMigrationTable.migrateAttributes.allValues) {
        [attribute.previousAttribute.sqliteColumns enumerateObjectsUsingBlock:^(VVSQLiteColumnModel *previousSQLiteColumn, NSUInteger idx, BOOL *stop) {
            VVSQLiteColumnModel *latestSQLiteColumn = attribute.latestAttbiute.sqliteColumns[idx];
            [sqlSelect appendString:previousSQLiteColumn.columnName];
            [sqlSelect appendString:@" as "];
            [sqlSelect appendString:latestSQLiteColumn.columnName];
            [sqlSelect appendString:@","];
        }];
    }
    [sqlSelect appendString:@"__createdAt__"];
    [sqlSelect appendString:@",__updatedAt__"];
    [sqlSelect appendString:@" "];
    [sqlSelect appendString:@"FROM"];
    [sqlSelect appendString:@" "];
    [sqlSelect appendString:fromMigrationTable.tableName];

    NSMutableString *sql = [NSMutableString string];
    [sql appendString:sqlInsert];
    [sql appendString:sqlSelect];
    return [NSString stringWithString:sql];
}

+ (NSString *)dropTableStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSString *tableName = migrationTable.tableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"DROP TABLE IF EXISTS "];
    [sql appendString:tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)deleteFromStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSString *tableName = migrationTable.temporaryTableName;
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@", tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)createTempTableStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSMutableArray *sqliteColumns = [NSMutableArray array];
    for (VVMigrationRuntimeProperty *attribute in migrationTable.attributes.allValues) {
        if (![attribute.name isEqualToString:@"rowid"]) {
            for (VVSQLiteColumnModel *sqliteColumn in attribute.latestAttbiute.sqliteColumns) {
                [sqliteColumns addObject:sqliteColumn];
            }
        }
    }
    return [VVQueryBuilder createTableStatement:migrationTable.temporaryTableName fullTextSearch3:migrationTable.fullTextSearch3 fullTextSearch4:migrationTable.fullTextSearch4 sqliteColumns:sqliteColumns];
}

+ (NSString *)createTemporaryUniqueIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSMutableArray *sqliteColumns = [NSMutableArray array];
    for (VVMigrationRuntimeProperty *attribute in migrationTable.identicalAttributes.allValues) {
        for (VVSQLiteColumnModel *sqliteColumn in attribute.latestAttbiute.sqliteColumns) {
            [sqliteColumns addObject:sqliteColumn];
        }
    }
    return [VVQueryBuilder createUniqueIndexStatement:migrationTable.temporaryTableName sqliteColumns:sqliteColumns];
}

+ (NSString *)createUniqueIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSMutableArray *sqliteColumns = [NSMutableArray array];
    for (VVMigrationRuntimeProperty *attribute in migrationTable.identicalAttributes.allValues) {
        for (VVSQLiteColumnModel *sqliteColumn in attribute.latestAttbiute.sqliteColumns) {
            [sqliteColumns addObject:sqliteColumn];
        }
    }
    return [VVQueryBuilder createUniqueIndexStatement:migrationTable.tableName sqliteColumns:sqliteColumns];
}

+ (NSString *)alterTableRenameStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"ALTER TABLE"];
    [sql appendString:@" "];
    [sql appendString:migrationTable.temporaryTableName];
    [sql appendString:@" "];
    [sql appendString:@"RENAME TO"];
    [sql appendString:@" "];
    [sql appendString:migrationTable.tableName];
    return [NSString stringWithString:sql];
}

+ (NSString *)dropTempIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable {
    NSString *tableName = migrationTable.temporaryTableName;
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"DROP INDEX IF EXISTS "];
    [sql appendString:[VVQueryBuilder uniqueIndexNameWithTableName:tableName]];
    return [NSString stringWithString:sql];
}


@end
