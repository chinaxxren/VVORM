//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVModelMapper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabaseAdditions.h>

#import "VVConditionModel.h"
#import "VVModelInterface.h"
#import "VVORMProperty.h"
#import "VVORMRelationship.h"
#import "VVORMClass.h"
#import "VVSQLiteConditionModel.h"
#import "VVSQLiteColumnModel.h"
#import "FMDatabase+indexInfo.h"
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
        for (VVORMProperty *ormProperty in ormClass.insertAttributes) {
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
                        VVORMProperty *attribute = ormClass.identificationAttributes[i];
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

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db {
    [self updateRowid:object db:db];
    if (!object.rowid) {
        return nil;
    }
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"toTableName = ? and toRowid = ?";
    condition.sqlite.parameters = @[object.VVORMClass.tableName, object.rowid];
    NSString *sql = [object.VVORMClass referencedCountStatementWithCondition:condition];
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

- (NSMutableArray *)select:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db {
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
        targetObject.VVORMClass = ormClass;
        for (VVORMProperty *attribute in targetObject.VVORMClass.simpleValueAttributes) {
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
    } else if (object.VVORMClass.hasIdentificationAttributes) {
        if (object.VVORMClass.insertPerformance) {
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
    NSString *sql = [object.VVORMClass insertOrReplaceIntoStatement];
    NSMutableArray *parameters = [object.VVORMClass insertOrReplaceAttributesParameters:object];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)updateByRowId:(NSObject *)object db:(FMDatabase *)db {
    VVConditionModel *condition = [object.VVORMClass rowidCondition:object];
    NSString *sql = [object.VVORMClass updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.VVORMClass updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)insertByIdentificationAttributes:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.VVORMClass insertOrIgnoreIntoStatement];
    NSMutableArray *parameters = [object.VVORMClass insertOrIgnoreAttributesParameters:object];
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
    VVConditionModel *condition = [object.VVORMClass uniqueCondition:object];
    NSString *sql = [object.VVORMClass updateStatementWithObject:object condition:condition];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[object.VVORMClass updateAttributesParameters:object]];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    [db executeUpdate:sql withArgumentsInArray:parameters];
    if ([self hadError:db]) {
        return NO;
    }
    [self updateRowid:object db:db];
    return YES;
}

- (BOOL)insert:(NSObject *)object db:(FMDatabase *)db {
    NSString *sql = [object.VVORMClass insertIntoStatement];
    NSMutableArray *parameters = [object.VVORMClass insertAttributesParameters:object];
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
    VVConditionModel *condition = [object.VVORMClass rowidCondition:object];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    NSString *sql = [object.VVORMClass deleteFromStatementWithCondition:condition];
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
    } else if (!object.VVORMClass.hasIdentificationAttributes) {
        return;
    }
    VVConditionModel *condition = [object.VVORMClass uniqueCondition:object];
    NSString *sql = [object.VVORMClass selectRowidStatement:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    while (rs.next) {
        object.rowid = [object.VVORMClass.rowidAttribute valueWithResultSet:rs];
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
    VVConditionModel *condition = [object.VVORMClass rowidCondition:object];
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:condition.sqlite.parameters];
    NSString *sql = [object.VVORMClass selectStatementWithCondition:condition];
    FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:condition.sqlite.parameters];
    if ([self hadError:db]) {
        return;
    }
    while ([rs next]) {
        for (VVORMProperty *attribute in object.VVORMClass.simpleValueAttributes) {
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

- (NSMutableArray *)relationshipObjectsWithObject:(NSObject *)object attribute:(VVORMProperty *)attribute relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSString *fromClassName = NSStringFromClass([object class]);
    NSString *fromAttributeName = attribute.name;
    NSNumber *fromRowid = object.rowid;
    NSArray *parameters = @[fromClassName, fromAttributeName, fromRowid];
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ?";
    condition.sqlite.orderBy = @"attributeLevel desc,attributeSequence asc,attributeParentLevel desc,attributeParentSequence asc";
    condition.sqlite.parameters = parameters;
    return [self relationshipObjectsWithCondition:condition relationshipORMClass:relationshipORMClass db:db];
}

- (NSMutableArray *)relationshipObjectsWithToObject:(NSObject *)toObject relationshipRuntime:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"toClassName = ? and toRowid = ?";
    condition.sqlite.orderBy = @"toClassName,toRowid";
    condition.sqlite.parameters = @[NSStringFromClass([toObject class]), toObject.rowid];
    return [self relationshipObjectsWithCondition:condition relationshipORMClass:relationshipORMClass db:db];
}

- (NSMutableArray *)relationshipObjectsWithCondition:(VVConditionModel *)condition relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSMutableArray *list = [self select:relationshipORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return nil;
    }
    return list;
}

- (BOOL)insertRelationshipObjectsWithRelationshipObjects:(NSArray *)relationshipObjects db:(FMDatabase *)db {
    for (VVORMRelationship *relationshipObject in relationshipObjects) {
        [self insertOrUpdate:relationshipObject db:db];
        if ([self hadError:db]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithObject:(NSObject *)object attribute:(VVORMProperty *)attribute relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    NSString *attributeName = attribute.name;
    NSNumber *rowid = object.rowid;
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ?";
    condition.sqlite.parameters = @[className, attributeName, rowid];
    [self deleteFrom:relationshipORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithClazzName:(NSString *)className attribute:(VVORMProperty *)attribute relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSString *attributeName = attribute.name;
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ?";
    condition.sqlite.parameters = @[className, attributeName];
    [self deleteFrom:relationshipORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithClazzName:(NSString *)className relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"fromClassName = ?";
    condition.sqlite.parameters = @[className];
    [self deleteFrom:relationshipORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithRelationshipObject:(VVORMRelationship *)relationshipObject db:(FMDatabase *)db {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"fromClassName = ? and fromAttributeName = ? and fromRowid = ? and toClassName = ? and toRowid = ?";
    condition.sqlite.parameters = @[relationshipObject.fromClassName, relationshipObject.fromAttributeName, relationshipObject.fromRowid, relationshipObject.toClassName, relationshipObject.toRowid];
    [self deleteFrom:relationshipObject.VVORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}


- (BOOL)deleteRelationshipObjectsWithFromObject:(NSObject *)object relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"(fromClassName = ? and fromRowid = ?)";
    condition.sqlite.parameters = @[className, object.rowid, className, object.rowid];
    [self deleteFrom:relationshipORMClass condition:condition db:db];
    if ([self hadError:db]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteRelationshipObjectsWithToObject:(NSObject *)object relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db {
    NSString *className = NSStringFromClass([object class]);
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = @"(toClassName = ? and toRowid = ?)";
    condition.sqlite.parameters = @[className, object.rowid, className, object.rowid];
    [self deleteFrom:relationshipORMClass condition:condition db:db];
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
