//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVModelMapper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabaseAdditions.h>

#import "VVConditionModel.h"
#import "VVModelInterface.h"
#import "VVPropertyInfo.h"
#import "VVORMClass.h"
#import "VVSQLiteConditionModel.h"
#import "VVSQLiteColumnModel.h"
#import "FMDatabase+IndexInfo.h"
#import "NSObject+VVTabel.h"

@implementation VVModelMapper

- (BOOL)createTable:(VVORMClass *)ormClass db:(FMDatabase *)db {
    BOOL tableExists = [db tableExists:ormClass.tableName];
    if (!tableExists) {
        [db executeUpdate:[ormClass createTableStatement]];
        if ([self hadError:db]) {
            return NO;
        }

        if (!ormClass.fullTextSearch3 && !ormClass.fullTextSearch4 && ormClass.hasIdentificationAttributes) {
            [db executeUpdate:[ormClass createUniqueIndexStatement]];
            if ([self hadError:db]) {
                return NO;
            }
        }

    } else {
        for (VVPropertyInfo *ormProperty in ormClass.insertAttributes) {
            for (VVSQLiteColumnModel *sqliteColumn in ormProperty.sqliteColumns) {
                if (![db columnExists:sqliteColumn.columnName inTableWithName:ormClass.tableName]) {
                    NSString *sql = [ormProperty alterTableAddColumnStatement:sqliteColumn];
                    [db executeUpdate:sql];
                    if ([self hadError:db]) {
                        return NO;
                    }
                }
            }
        }

        if (!ormClass.hasIdentificationAttributes || ormClass.fullTextSearch3 || ormClass.fullTextSearch4) {
            BOOL indexExists = [db indexExists:ormClass.uniqueIndexName];
            if (indexExists) {
                [db executeUpdate:[ormClass dropUniqueIndexStatement]];
                if ([self hadError:db]) {
                    return NO;
                }
            }

        } else {
            BOOL indexExists = [db indexExists:ormClass.uniqueIndexName];
            if (!indexExists) {
                [db executeUpdate:[ormClass createUniqueIndexStatement]];
                if ([self hadError:db]) {
                    return NO;
                }
            } else {
                BOOL changed = NO;
                NSArray *columnNames = [db columnNamesWithIndexName:ormClass.uniqueIndexName];
                if (columnNames.count != ormClass.identificationAttributes.count) {
                    changed = YES;
                } else {
                    for (NSInteger i = 0; i < columnNames.count; i++) {
                        VVPropertyInfo *attribute = ormClass.identificationAttributes[i];
                        NSString *columnNameFrom = columnNames[i];
                        NSString *columnNameTo = attribute.name;
                        if (![columnNameFrom isEqualToString:columnNameTo]) {
                            changed = YES;
                            break;
                        }
                    }
                }
                if (changed) {
                    [db executeUpdate:[ormClass dropUniqueIndexStatement]];
                    if ([self hadError:db]) {
                        return NO;
                    }
                    [db executeUpdate:[ormClass createUniqueIndexStatement]];
                    if ([self hadError:db]) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}


#pragma mark create, drop

- (BOOL)dropTable:(VVORMClass *)runtime db:(FMDatabase *)db {
    BOOL tableExists = [db tableExists:runtime.tableName];
    if (tableExists) {
        [db executeUpdate:[runtime dropTableStatement]];
        if ([self hadError:db]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark avg, total, sum, min, max, count, referencedCount

- (NSNumber *)avg:(VVORMClass *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime avgStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)total:(VVORMClass *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime totalStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)sum:(VVORMClass *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime sumStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)min:(VVORMClass *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime minStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)max:(VVORMClass *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime maxStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)count:(VVORMClass *)runtime condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime countStatementWithCondition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)groupWithStatement:(NSString *)statement condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    FMResultSet *rs = [db executeQuery:statement withArgumentsInArray:condition.sqlite.parameters];
    if ([self hadError:db]) {
        return nil;
    }
    NSNumber *value = nil;
    while (rs.next) {
        value = [rs objectForColumnIndex:0];
    }
    [rs close];
    return value;
}

#pragma mark insert, update, delete

- (NSMutableArray *)find:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [ormClass selectStatementWithCondition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];

    NSMutableArray *list = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    if ([self hadError:db]) {
        return nil;
    }
    while ([rs next]) {
        NSObject *targetObject = [ormClass object];
        targetObject.ormClass = ormClass;
        for (VVPropertyInfo *attribute in targetObject.ormClass.simpleValueAttributes) {
            NSObject *value = [attribute valueWithResultSet:rs];
            [targetObject setValue:value forKey:attribute.name];
        }
        [list addObject:targetObject];
    }
    [rs close];
    return list;
}

- (BOOL)insertOrUpdate:(NSObject *)object db:(FMDatabase *)db {
    if (object.rowid) {
        [self updateByRowId:object db:db];
        int changes = [db changes];
        if (changes == 0) {
            [self insertByRowId:object db:db];
        }
    } else if (object.ormClass.hasIdentificationAttributes) {
        if (object.ormClass.insertPerformance) {
            [self insertByIdentificationAttributes:object db:db];
            if (!object.rowid) {
                [self updateByIdentificationAttributes:object db:db];
            }
        } else {
            [self updateByIdentificationAttributes:object db:db];
            if (!object.rowid) {
                [self insertByIdentificationAttributes:object db:db];
            }
        }
    } else if (!object.rowid) {
        [self insert:object db:db];
    }
    return YES;
}

- (BOOL)insertByRowId:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.ormClass insertOrReplaceIntoStatement];
    NSMutableArray *parameters = [object.ormClass insertOrReplaceAttributesParameters:object];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)updateByRowId:(NSObject *)object db:(FMDatabase *)db {
    VVConditionModel *condition = [object.ormClass rowidCondition:object];
    NSString *sql = [object.ormClass updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.ormClass updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)insertByIdentificationAttributes:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.ormClass insertOrIgnoreIntoStatement];
    NSMutableArray *parameters = [object.ormClass insertOrIgnoreAttributesParameters:object];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    int changes = [db changes];
    if (changes > 0) {
        int64_t lastInsertRowid = [db lastInsertRowId];
        object.rowid = @(lastInsertRowid);
    }
    return YES;
}

- (BOOL)updateByIdentificationAttributes:(NSObject *)object db:(FMDatabase *)db {
    VVConditionModel *condition = [object.ormClass uniqueCondition:object];
    NSString *sql = [object.ormClass updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.ormClass updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    [self updateRowid:object db:db];
    return YES;
}

- (BOOL)insert:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.ormClass insertIntoStatement];
    NSMutableArray *parameters = [object.ormClass insertAttributesParameters:object];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    int changes = [db changes];
    if (changes > 0) {
        int64_t lastInsertRowid = [db lastInsertRowId];
        object.rowid = @(lastInsertRowid);
    }
    return YES;
}

- (BOOL)deleteFrom:(NSObject *)object db:(FMDatabase *)db {
    VVConditionModel *condition = [object.ormClass rowidCondition:object];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    NSString *sql = [object.ormClass deleteFromStatementWithCondition:condition];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteFrom:(VVORMClass *)runtime condition:(VVConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime deleteFromStatementWithCondition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

#pragma mark object update methods

- (void)updateRowid:(NSObject *)object db:(FMDatabase *)db {
    if (object.rowid) {
        return;
    } else if (!object.ormClass.hasIdentificationAttributes) {
        return;
    }
    VVConditionModel *condition = [object.ormClass uniqueCondition:object];
    NSString *sql = [object.ormClass selectRowidStatement:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    while (rs.next) {
        object.rowid = [object.ormClass.rowidAttribute valueWithResultSet:rs];
        break;
    }
    [rs close];
}

- (void)updateRowidWithObjects:(NSArray *)objects db:(FMDatabase *)db {
    for (NSObject *object in objects) {
        [self updateRowid:object db:db];
    }
    return;
}

- (BOOL)hadError:(FMDatabase *)db {
    if ([db hadError]) {
        return YES;
    } else {
        return NO;
    }
}

@end
