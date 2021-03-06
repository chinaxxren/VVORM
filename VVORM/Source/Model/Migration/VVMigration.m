//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMigration.h"

#import <FMDB/FMDatabase.h>

#import "VVORMClass.h"
#import "VVPropertyInfo.h"
#import "VVMigrationRuntime.h"
#import "VVMigrationRuntimeProperty.h"
#import "VVMigrationTable.h"
#import "VVMigrationQueryBuilder.h"


@interface VVReferenceMapper (Protected)

- (NSMutableArray *)findObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)saveObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)deleteObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error;

- (VVORMClass *)ormClass:(Class)clazz;

- (BOOL)hadError:(FMDatabase *)db error:(NSError **)error;

@end

@implementation VVMigration

- (BOOL)migrate:(FMDatabase *)db error:(NSError **)error {

    // Get previous class and current class information
    NSMutableDictionary *currentRuntimes = [NSMutableDictionary dictionary];
    NSMutableArray *previousRuntimes = [self findObjects:[VVORMClass class] condition:nil db:db error:error];
    for (VVORMClass *runtime in previousRuntimes) {
        Class clazz = NSClassFromString(runtime.clazzName);
        if (clazz) {
            VVORMClass *currentRuntime = [self ormClass:clazz];
            currentRuntimes[currentRuntime.clazzName] = currentRuntime;
        }
    }

    // create migration list
    NSMutableDictionary *migrationRuntimes = [NSMutableDictionary dictionary];
    for (VVORMClass *runtime in previousRuntimes) {
        VVMigrationRuntime *migrationRuntime = [[VVMigrationRuntime alloc] init];
        migrationRuntime.clazzName = runtime.clazzName;
        migrationRuntime.previousRuntime = runtime;
        VVORMClass *latestRuntime = currentRuntimes[runtime.clazzName];
        migrationRuntime.latestRuntime = latestRuntime;
        migrationRuntime.attributes = [NSMutableDictionary dictionary];
        migrationRuntimes[migrationRuntime.clazzName] = migrationRuntime;
    }

    // create migration property list
    for (VVMigrationRuntime *migrationRuntime in migrationRuntimes.allValues) {
        VVORMClass *latestRuntime = migrationRuntime.latestRuntime;
        for (VVPropertyInfo *attribute in latestRuntime.attributes) {
            VVMigrationRuntimeProperty *migrationAttribute = migrationRuntime.attributes[attribute.name];
            if (!migrationAttribute) {
                migrationAttribute = [[VVMigrationRuntimeProperty alloc] init];
                migrationAttribute.name = attribute.name;
                migrationRuntime.attributes[attribute.name] = migrationAttribute;
            }
            migrationAttribute.latestAttbiute = attribute;
        }
        VVORMClass *previousRuntime = migrationRuntime.previousRuntime;
        for (VVPropertyInfo *attribute in previousRuntime.attributes) {
            VVMigrationRuntimeProperty *migrationAttribute = migrationRuntime.attributes[attribute.name];
            if (!migrationAttribute) {
                migrationAttribute = [[VVMigrationRuntimeProperty alloc] init];
                migrationAttribute.name = attribute.name;
                migrationRuntime.attributes[attribute.name] = migrationAttribute;
            }
            migrationAttribute.previousAttribute = attribute;
        }
    }

    // get migration type
    for (VVMigrationRuntime *migrationRuntime in migrationRuntimes.allValues) {
        for (VVMigrationRuntimeProperty *migrationAttribute in migrationRuntime.attributes.allValues) {
            migrationAttribute.added = migrationAttribute.latestAttbiute && !migrationAttribute.previousAttribute;
            migrationAttribute.deleted = !migrationAttribute.latestAttbiute && migrationAttribute.previousAttribute;
            migrationAttribute.typeChanged = ![migrationAttribute.latestAttbiute.attributeType isEqualToString:migrationAttribute.previousAttribute.attributeType];
            migrationAttribute.columnNameChanged = ![migrationAttribute.latestAttbiute.columnName isEqualToString:migrationAttribute.previousAttribute.columnName];
            if (migrationAttribute.deleted) {
                migrationRuntime.changed = YES;
            } else if (migrationAttribute.added) {
                migrationRuntime.changed = YES;
            } else if (migrationAttribute.typeChanged) {
                migrationRuntime.changed = YES;
            } else if (migrationAttribute.columnNameChanged) {
                migrationRuntime.changed = YES;
            }
        }
        if (migrationRuntime.latestRuntime && migrationRuntime.previousRuntime) {
            if (![migrationRuntime.latestRuntime.tableName isEqualToString:migrationRuntime.previousRuntime.tableName]) {
                migrationRuntime.tableNameChanged = YES;
                migrationRuntime.changed = YES;
            }
        } else if (!migrationRuntime.latestRuntime && migrationRuntime.previousRuntime) {
            migrationRuntime.deleted = YES;
        }

    }

    // get table list
    NSMutableDictionary *previousMigrationTables = [NSMutableDictionary dictionary];
    NSMutableDictionary *migrationTables = [NSMutableDictionary dictionary];
    for (VVMigrationRuntime *migrationRuntime in migrationRuntimes.allValues) {
        if (migrationRuntime.changed) {

            VVMigrationTable *migrationTable = nil;
            if (migrationRuntime.latestRuntime) {
                NSString *tableName = migrationRuntime.latestRuntime.tableName;
                migrationTable = migrationTables[tableName];
                if (!migrationTable) {
                    migrationTable = [[VVMigrationTable alloc] init];
                    migrationTable.tableName = migrationRuntime.latestRuntime.tableName;
                    migrationTable.temporaryTableName = [NSString stringWithFormat:@"__%@__", migrationRuntime.latestRuntime.tableName];
                    migrationTable.previousTables = [NSMutableDictionary dictionary];
                    migrationTable.attributes = [NSMutableDictionary dictionary];
                    migrationTable.identicalAttributes = [NSMutableDictionary dictionary];
                }
                migrationTable.fullTextSearch3 = migrationRuntime.latestRuntime.fullTextSearch3;
                migrationTable.fullTextSearch4 = migrationRuntime.latestRuntime.fullTextSearch4;
                migrationTables[migrationTable.tableName] = migrationTable;
                for (VVMigrationRuntimeProperty *migrationAttribute in migrationRuntime.attributes.allValues) {
                    migrationTable.attributes[migrationAttribute.name] = migrationAttribute;
                    if (migrationAttribute.latestAttbiute.identicalAttribute) {
                        migrationTable.identicalAttributes[migrationAttribute.name] = migrationAttribute;
                    }
                }
            }

            VVMigrationTable *previousMigrationTable = nil;
            if (migrationRuntime.previousRuntime) {
                previousMigrationTable = migrationTable.previousTables[migrationRuntime.previousRuntime.tableName];
                if (!previousMigrationTable) {
                    previousMigrationTable = [[VVMigrationTable alloc] init];
                    previousMigrationTable.tableName = migrationRuntime.previousRuntime.tableName;
                    previousMigrationTable.temporaryTableName = [NSString stringWithFormat:@"__%@__", migrationRuntime.previousRuntime.tableName];
                    previousMigrationTable.previousTables = [NSMutableDictionary dictionary];
                    previousMigrationTable.attributes = [NSMutableDictionary dictionary];
                    previousMigrationTable.migrateAttributes = [NSMutableDictionary dictionary];
                    previousMigrationTable.identicalAttributes = [NSMutableDictionary dictionary];
                }
                for (VVMigrationRuntimeProperty *migrationAttribute in migrationRuntime.attributes.allValues) {
                    previousMigrationTable.attributes[migrationAttribute.name] = migrationAttribute;
                    if (!migrationAttribute.deleted && !migrationAttribute.typeChanged && !migrationAttribute.added) {
                        previousMigrationTable.migrateAttributes[migrationAttribute.name] = migrationAttribute;
                    }
                }
            }
            if (migrationTable && previousMigrationTable) {
                migrationTable.previousTables[previousMigrationTable.tableName] = previousMigrationTable;
            }
            if (previousMigrationTable) {
                previousMigrationTables[previousMigrationTable.tableName] = previousMigrationTable;
            }
        }
    }

    // get table migration type
    for (VVMigrationTable *previousMigrationTable in previousMigrationTables.allValues) {
        previousMigrationTable.deleted = YES;
        for (VVMigrationTable *latestMigrationTable in migrationTables.allValues) {
            if ([previousMigrationTable.tableName isEqualToString:latestMigrationTable.tableName]) {
                previousMigrationTable.deleted = NO;
                break;
            }
        }
    }

    // start migration

    // update runtime information
    for (VVMigrationRuntime *migrationRuntime in migrationRuntimes.allValues) {
        if (migrationRuntime.changed) {
            [self saveObjects:@[migrationRuntime.latestRuntime] db:db error:error];
            if ([self hadError:db error:error]) {
                return NO;
            }
        } else if (migrationRuntime.deleted) {
            [self deleteObjects:@[migrationRuntime.latestRuntime] db:db error:error];
            if ([self hadError:db error:error]) {
                return NO;
            }
        }
    }

    // migration table
    for (VVMigrationTable *migrationTable in migrationTables.allValues) {

        // create temporary table
        NSString *createTempTableSql = [VVMigrationQueryBuilder createTempTableStatementWithMigrationTable:migrationTable];
        [db executeStatements:createTempTableSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        // delte temporary table data
        NSString *deleteTempTableSql = [VVMigrationQueryBuilder deleteFromStatementWithMigrationTable:migrationTable];
        [db executeStatements:deleteTempTableSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        // create temporary index
        NSString *createTempIndexSql = [VVMigrationQueryBuilder createTemporaryUniqueIndexStatementWithMigrationTable:migrationTable];
        [db executeStatements:createTempIndexSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        for (VVMigrationTable *previousMigrationTable in migrationTable.previousTables.allValues) {

            // copy data from previous to current table
            NSString *selectInsertSql = [VVMigrationQueryBuilder selectInsertStatementWithToMigrationTable:migrationTable fromMigrationTable:previousMigrationTable];
            [db executeStatements:selectInsertSql];
            if ([self hadError:db error:error]) {
                return NO;
            }

            // drop previous table
            if (previousMigrationTable.deleted) {
                NSString *dropSql = [VVMigrationQueryBuilder dropTableStatementWithMigrationTable:previousMigrationTable];
                [db executeStatements:dropSql];
                if ([self hadError:db error:error]) {
                    return NO;
                }
            }

        }

        // drop temporary index
        NSString *dropIndexSql = [VVMigrationQueryBuilder dropTempIndexStatementWithMigrationTable:migrationTable];
        [db executeStatements:dropIndexSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        // drop table
        NSString *dropSql = [VVMigrationQueryBuilder dropTableStatementWithMigrationTable:migrationTable];
        [db executeStatements:dropSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        // rename temporary table
        NSString *renameSql = [VVMigrationQueryBuilder alterTableRenameStatementWithMigrationTable:migrationTable];
        [db executeStatements:renameSql];
        if ([self hadError:db error:error]) {
            return NO;
        }

        // create index
        NSString *createIndexSql = [VVMigrationQueryBuilder createUniqueIndexStatementWithMigrationTable:migrationTable];
        [db executeStatements:createIndexSql];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)hadError:(FMDatabase *)db error:(NSError **)error {
    if ([db hadError]) {
        return YES;
    } else if (error) {
        if (*error) {
            return YES;
        }
    }
    return NO;
}

@end
