//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVModelMapper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabaseAdditions.h>

#import "VVDBConditionModel.h"
#import "VVModelInterface.h"
#import "VVDBRuntimeProperty.h"
#import "VVRelationshipModel.h"
#import "VVDBRuntime.h"
#import "VVDBSQLiteConditionModel.h"
#import "VVSQLiteColumnModel.h"
#import "FMDatabase+indexInfo.h"
#import "NSObject+VVTabel.h"

@implementation VVModelMapper

- (BOOL)createTable:(VVDBRuntime *)runtime db:(FMDatabase *)db {
    BOOL tableExists = [db tableExists:runtime.tableName];
    if (!tableExists) {
        [db executeUpdate:[runtime createTableStatement]];
        if ([self hadError:db]) {
            return NO;
        }
        if (!runtime.fullTextSearch3 && !runtime.fullTextSearch4 && runtime.hasIdentificationAttributes) {
            [db executeUpdate:[runtime createUniqueIndexStatement]];
            if ([self hadError:db]) {
                return NO;
            }
        }
    } else {
        for (VVDBRuntimeProperty *attribute in runtime.insertAttributes) {
            for (VVSQLiteColumnModel *sqliteColumn in attribute.sqliteColumns) {
                if (![db columnExists:sqliteColumn.columnName inTableWithName:runtime.tableName]) {
                    NSString *sql = [attribute alterTableAddColumnStatement:sqliteColumn];
                    [db executeUpdate:sql];
                    if ([self hadError:db]) {
                        return NO;
                    }
                }
            }

        }
        if (!runtime.hasIdentificationAttributes || runtime.fullTextSearch3 || runtime.fullTextSearch4) {
            BOOL indexExists = [db indexExists:runtime.uniqueIndexName];
            if (indexExists) {
                [db executeUpdate:[runtime dropUniqueIndexStatement]];
                if ([self hadError:db]) {
                    return NO;
                }
            }

        } else {
            BOOL indexExists = [db indexExists:runtime.uniqueIndexName];
            if (!indexExists) {
                [db executeUpdate:[runtime createUniqueIndexStatement]];
                if ([self hadError:db]) {
                    return NO;
                }
            } else {
                BOOL changed = NO;
                NSArray *columnNames = [db columnNamesWithIndexName:runtime.uniqueIndexName];
                if (columnNames.count != runtime.identificationAttributes.count) {
                    changed = YES;
                } else {
                    for (NSInteger i = 0; i < columnNames.count; i++) {
                        VVDBRuntimeProperty *attribute = runtime.identificationAttributes[i];
                        NSString *columnNameFrom = columnNames[i];
                        NSString *columnNameTo = attribute.name;
                        if (![columnNameFrom isEqualToString:columnNameTo]) {
                            changed = YES;
                            break;
                        }
                    }
                }
                if (changed) {
                    [db executeUpdate:[runtime dropUniqueIndexStatement]];
                    if ([self hadError:db]) {
                        return NO;
                    }
                    [db executeUpdate:[runtime createUniqueIndexStatement]];
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

- (BOOL)dropTable:(VVDBRuntime *)runtime db:(FMDatabase *)db {
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

- (NSNumber *)avg:(VVDBRuntime *)runtime columnName:(NSString *)columnName condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime avgStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)total:(VVDBRuntime *)runtime columnName:(NSString *)columnName condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime totalStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)sum:(VVDBRuntime *)runtime columnName:(NSString *)columnName condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime sumStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)min:(VVDBRuntime *)runtime columnName:(NSString *)columnName condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime minStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)max:(VVDBRuntime *)runtime columnName:(NSString *)columnName condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime maxStatementWithColumnName:columnName condition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)count:(VVDBRuntime *)runtime condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime countStatementWithCondition:condition];
    NSNumber *value = [self groupWithStatement:sql condition:condition db:db];
    return value;
}

- (NSNumber *)groupWithStatement:(NSString *)statement condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
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

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db {
    [self updateRowid:object db:db];
    if (!object.rowid) {
        return nil;
    }
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"toTableName = ? and toRowid = ?";
    condition.sqlite.parameters = @[object.VVRuntime.tableName, object.rowid];
    NSString *sql = [object.VVRuntime referencedCountStatementWithCondition:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
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

- (NSMutableArray *)select:(VVDBRuntime *)runtime condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
    NSString *sql = [runtime selectStatementWithCondition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];

    NSMutableArray *list = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    if ([self hadError:db]) {
        return nil;
    }
    while ([rs next]) {
        NSObject *targetObject = [runtime object];
        targetObject.VVRuntime = runtime;
        for (VVDBRuntimeProperty *attribute in targetObject.VVRuntime.simpleValueAttributes) {
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
    } else if (object.VVRuntime.hasIdentificationAttributes) {
        if (object.VVRuntime.insertPerformance) {
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
    NSString *sql = [object.VVRuntime insertOrReplaceIntoStatement];
    NSMutableArray *parameters = [object.VVRuntime insertOrReplaceAttributesParameters:object];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)updateByRowId:(NSObject *)object db:(FMDatabase *)db {
    VVDBConditionModel *condition = [object.VVRuntime rowidCondition:object];
    NSString *sql = [object.VVRuntime updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.VVRuntime updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)insertByIdentificationAttributes:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.VVRuntime insertOrIgnoreIntoStatement];
    NSMutableArray *parameters = [object.VVRuntime insertOrIgnoreAttributesParameters:object];
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
    VVDBConditionModel *condition = [object.VVRuntime uniqueCondition:object];
    NSString *sql = [object.VVRuntime updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.VVRuntime updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    [self updateRowid:object db:db];
    return YES;
}

- (BOOL)insert:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.VVRuntime insertIntoStatement];
    NSMutableArray *parameters = [object.VVRuntime insertAttributesParameters:object];
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
    VVDBConditionModel *condition = [object.VVRuntime rowidCondition:object];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    NSString *sql = [object.VVRuntime deleteFromStatementWithCondition:condition];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteFrom:(VVDBRuntime *)runtime condition:(VVDBConditionModel *)condition db:(FMDatabase *)db {
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
    } else if (!object.VVRuntime.hasIdentificationAttributes) {
        return;
    }
    VVDBConditionModel *condition = [object.VVRuntime uniqueCondition:object];
    NSString *sql = [object.VVRuntime selectRowidStatement:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    while (rs.next) {
        object.rowid = [object.VVRuntime.rowidAttribute valueWithResultSet:rs];
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

- (void)updateSimpleValueWithObject:(NSObject *)object db:(FMDatabase *)db {
    VVDBConditionModel *condition = [object.VVRuntime rowidCondition:object];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    NSString *sql = [object.VVRuntime selectStatementWithCondition:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    if ([self hadError:db]) {
        return;
    }
    while ([rs next]) {
        for (VVDBRuntimeProperty *attribute in object.VVRuntime.simpleValueAttributes) {
            if (!attribute.isRelationshipClazz) {
                NSObject *value = [attribute valueWithResultSet:rs];
                [object setValue:value forKey:attribute.name];
            }
        }
        break;
    }
    [rs close];
}


#pragma mark relationship methods

- (NSMutableArray *)relationshipObjectsWithObject:(NSObject *)object attribute:(VVDBRuntimeProperty *)attribute relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSString *fromClassName = NSStringFromClass([object class]);
    NSString *fromAttributeName = attribute.name;
    NSNumber *fromRowid = object.rowid;
    NSArray *parameters = @[fromClassName, fromAttributeName, fromRowid];
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ?";
    condition.sqlite.orderBy = @"attributeLevel desc,attributeSequence asc,attributeParentLevel desc,attributeParentSequence asc";
    condition.sqlite.parameters = parameters;
    return [self relationshipObjectsWithCondition:condition relationshipRuntime:relationshipRuntime db:db];
}

- (NSMutableArray *)relationshipObjectsWithToObject:(NSObject *)toObject relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"toClassName = ? and toRowid = ?";
    condition.sqlite.orderBy = @"toClassName,toRowid";
    condition.sqlite.parameters = @[NSStringFromClass([toObject class]), toObject.rowid];
    return [self relationshipObjectsWithCondition:condition relationshipRuntime:relationshipRuntime db:db];
}

- (NSMutableArray *)relationshipObjectsWithCondition:(VVDBConditionModel *)condition relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSMutableArray *list = [self select:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return nil;
    }
    return list;
}

- (BOOL)insertRelationshipObjectsWithRelationshipObjects:(NSArray *)relationshipObjects db:(FMDatabase *)db {
    for (VVRelationshipModel *relationshipObject in relationshipObjects) {
        [self insertOrUpdate:relationshipObject db:db];
        if ([self hadError:db]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithObject:(NSObject *)object attribute:(VVDBRuntimeProperty *)attribute relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    NSString *attributeName = attribute.name;
    NSNumber *rowid = object.rowid;
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ?";
    condition.sqlite.parameters = @[className, attributeName, rowid];
    [self deleteFrom:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithClazzName:(NSString *)className attribute:(VVDBRuntimeProperty *)attribute relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSString *attributeName = attribute.name;
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ?";
    condition.sqlite.parameters = @[className, attributeName];
    [self deleteFrom:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithClazzName:(NSString *)className relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"fromClassName = ?";
    condition.sqlite.parameters = @[className];
    [self deleteFrom:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithRelationshipObject:(VVRelationshipModel *)relationshipObject db:(FMDatabase *)db {
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ? and toClassName = ? and toRowid = ?";
    condition.sqlite.parameters = @[relationshipObject.fromClassName, relationshipObject.fromAttributeName, relationshipObject.fromRowid, relationshipObject.toClassName, relationshipObject.toRowid];
    [self deleteFrom:relationshipObject.VVRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}


- (BOOL)deleteRelationshipObjectsWithFromObject:(NSObject *)object relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"(fromClassName = ? and fromRowid = ?)";
    condition.sqlite.parameters = @[className, object.rowid, className, object.rowid];
    [self deleteFrom:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithToObject:(NSObject *)object relationshipRuntime:(VVDBRuntime *)relationshipRuntime db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = @"(toClassName = ? and toRowid = ?)";
    condition.sqlite.parameters = @[className, object.rowid, className, object.rowid];
    [self deleteFrom:relationshipRuntime condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}


- (BOOL)hadError:(FMDatabase *)db {
    if ([db hadError]) {
        return YES;
    } else {
        return NO;
    }
}

@end
