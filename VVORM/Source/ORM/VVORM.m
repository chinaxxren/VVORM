//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVORM.h"

#import <FMDB/FMDatabaseQueue.h>
#import <sqlite3.h>

#import "VVModelInterface.h"
#import "VVORMRelationship.h"
#import "VVORMClass.h"
#import "VVORMProperty.h"
#import "VVSQLiteConditionModel.h"

@interface VVMigration (Protected)

- (BOOL)migrate:(FMDatabase *)db error:(NSError **)error;

@end

@interface VVReferenceMapper (Protected)

- (NSNumber *)existsObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error;

- (NSMutableArray *)fetchReferencingObjectsWithToObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error;

- (NSArray *)refreshObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error;

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)saveObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)deleteObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error;

- (VVORMClass *)ormClass:(Class)clazz;

- (BOOL)registerORMClass:(VVORMClass *)ormClass db:(FMDatabase *)db error:(NSError **)error;

- (BOOL)unRegisterORMClass:(VVORMClass *)ormClass db:(FMDatabase *)db error:(NSError **)error;

- (void)setUnRegistedAllRuntimeFlag;

- (void)setRegistedORMClassFlag:(VVORMClass *)ormClass;

- (void)setUnRegistedORMClassFlag:(VVORMClass *)ormClass;

@end


@interface VVORM ()

@property(nonatomic, weak) VVORM *weakSelf;
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@property(nonatomic, strong) FMDatabase *db;
@property(nonatomic, assign) BOOL rollback;

@end

@implementation VVORM

#pragma mark constractor method

+ (instancetype)openWithPath:(NSString *)path error:(NSError **)error {
    if (path && ![path isEqualToString:@""]) {
        if ([path isEqualToString:[path lastPathComponent]]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *dir = [paths firstObject];
            path = [dir stringByAppendingPathComponent:path];
#ifdef DEBUG
            NSLog(@"database path = %@", path);
#endif
        }
    }

    FMDatabaseQueue *dbQueue = [self dbQueueWithPath:path];
    if (!dbQueue) {
        return nil;
    }

    VVORM *os = [[self alloc] init];
    os.dbQueue = dbQueue;
    os.db = nil;
    os.weakSelf = os;

    NSError *err = nil;
    [os registerClass:[VVORMRelationship class] error:&err];
    if (err) {
        *error = err;
        return nil;
    }
    [os registerClass:[VVORMClass class] error:&err];
    if (err) {
        *error = err;
        return nil;
    }
    [os registerClass:[VVORMProperty class] error:&err];
    if (err) {
        *error = err;
        return nil;
    }
    return os;
}

+ (FMDatabaseQueue *)dbQueueWithPath:(NSString *)path {
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE];
    return dbQueue;
}

#pragma mark inTransaction

- (void)inTransactionWithBlock:(void (^)(FMDatabase *db, BOOL *rollback))block {
    @synchronized (self) {
        if (self.db) {
            if (block) {
                block(self.db, &_rollback);
            }
        } else {
            [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [_weakSelf transactionDidBegin:db];
                _weakSelf.db = db;
//                db.traceExecution = YES;
                [db setShouldCacheStatements:YES];
                block(db, rollback);
                if (*rollback) {
                    [_weakSelf setUnRegistedAllRuntimeFlag];
                }
            }];
            [self transactionDidEnd:self.db];
            self.db = nil;
        }
    }
}

- (void)transactionDidBegin:(FMDatabase *)db {

}

- (void)transactionDidEnd:(FMDatabase *)db {

}

#pragma mark transaction

- (void)inTransaction:(void (^)(VVORM *dataBase, BOOL *rollback))block {
    __weak VVORM *weakSelf = self;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        block(weakSelf, rollback);
    }];
}

#pragma mark exists, count, min, max methods

- (NSNumber *)existsObject:(NSObject *)object {
    return [self existsObject:object error:nil];
}

- (NSNumber *)existsObject:(NSObject *)object error:(NSError **)error {
    __block NSError *err = nil;
    __block NSNumber *exists = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        exists = [_weakSelf existsObject:object db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return exists;
}

- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition {
    return [self count:clazz condition:condition error:nil];
}

- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block NSNumber *value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf count:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition {
    return [self max:columnName class:clazz condition:condition error:nil];
}

- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block id value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf max:columnName class:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition {
    return [self min:columnName class:clazz condition:condition error:nil];
}

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block id value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf min:columnName class:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition {
    return [self total:columnName class:clazz condition:condition error:nil];
}

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block id value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf total:columnName class:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition {
    return [self sum:columnName class:clazz condition:condition error:nil];
}

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block id value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf sum:columnName class:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition {
    return [self avg:columnName class:clazz condition:condition error:nil];
}

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block id value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf avg:columnName class:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}


#pragma mark fetch count methods

- (NSNumber *)referencedCount:(NSObject *)object {
    return [self referencedCount:object error:nil];
}

- (NSNumber *)referencedCount:(NSObject *)object error:(NSError **)error {
    __block NSError *err = nil;
    __block NSNumber *value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf referencedCount:object db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSMutableArray *)fetchReferencingObjectsTo:(NSObject *)object {
    return [self fetchReferencingObjectsTo:object error:nil];
}

- (NSMutableArray *)fetchReferencingObjectsTo:(NSObject *)object error:(NSError **)error {
    __block NSError *err = nil;
    __block NSMutableArray *list = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        list = [_weakSelf fetchReferencingObjectsWithToObject:object db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return list;
}


#pragma mark fetch methods

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition {
    return [self fetchObjects:clazz condition:condition error:nil];
}

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block NSMutableArray *value = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        value = [_weakSelf fetchObjects:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return value;
}

- (NSMutableArray *)fetchObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy error:(NSError **)error {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    return [self fetchObjects:clazz condition:condition error:error];
}

- (NSMutableArray *)fetchObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy offset:(NSNumber *)offset limit:(NSNumber *)limit error:(NSError **)error {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    condition.sqlite.orderBy = orderBy;
    condition.sqlite.offset = offset;
    condition.sqlite.limit = limit;
    return [self fetchObjects:clazz condition:condition error:error];
}

- (id)refreshObject:(NSObject *)object {
    return [self referencedCount:object error:nil];
}

- (id)refreshObject:(NSObject *)object error:(NSError **)error {
    __block NSError *err = nil;
    __block NSObject *latestObject = nil;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        latestObject = [_weakSelf refreshObject:object db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return latestObject;
}


#pragma mark save methods

- (BOOL)saveObjects:(NSArray *)objects {
    return [self saveObjects:objects error:nil];
}

- (BOOL)saveObjects:(NSArray *)objects error:(NSError **)error {
    if (![[objects class] isSubclassOfClass:[NSArray class]]) {
        return NO;
    }
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        ret = [_weakSelf saveObjects:objects db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
        return;
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

- (BOOL)saveObject:(NSObject *)object {
    return [self saveObject:object error:nil];
}

- (BOOL)saveObject:(NSObject *)object error:(NSError **)error {
    if (!object) {
        return NO;
    }
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        ret = [_weakSelf saveObjects:@[object] db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

#pragma mark delete methods

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition {
    return [self deleteObjects:clazz condition:condition error:nil];
}

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error {
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        [db setShouldCacheStatements:YES];
        ret = [_weakSelf deleteObjects:clazz condition:condition db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
        return;
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

- (BOOL)deleteObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters error:(NSError **)error {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = where;
    condition.sqlite.parameters = parameters;
    return [self deleteObjects:clazz condition:condition error:error];
}

- (BOOL)deleteObject:(NSObject *)object {
    return [self deleteObject:object error:nil];
}

- (BOOL)deleteObject:(NSObject *)object error:(NSError **)error {
    if (!object) {
        return NO;
    }
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        ret = [_weakSelf deleteObjects:@[object] db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
        return;
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

- (BOOL)deleteObjects:(NSArray *)objects {
    return [self deleteObjects:objects error:nil];
}

- (BOOL)deleteObjects:(NSArray *)objects error:(NSError **)error {
    if (![[objects class] isSubclassOfClass:[NSArray class]]) {
        return NO;
    }
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        ret = [_weakSelf deleteObjects:objects db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

#pragma register methods

- (BOOL)registerClass:(Class)clazz {
    return [self registerClass:clazz error:nil];
}

- (BOOL)registerClass:(Class)clazz error:(NSError **)error {
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        VVORMClass *ormClass = [self ormClass:clazz];
        ret = [_weakSelf registerORMClass:ormClass db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
        [self setRegistedORMClassFlag:ormClass];
        return;
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

- (BOOL)unRegisterClass:(Class)clazz {
    return [self unRegisterClass:clazz error:nil];
}

- (BOOL)unRegisterClass:(Class)clazz error:(NSError **)error {
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        VVORMClass *ormClass = [self ormClass:clazz];
        ret = [_weakSelf unRegisterORMClass:ormClass db:db error:&err];
        if ([db hadError]) {
            err = [db lastError];
        }
        if (err) {
            *rollback = YES;
        }
        [self setUnRegistedORMClassFlag:ormClass];
        return;
    }];
    if (error) {
        *error = err;
    }
    return ret;
}

- (BOOL)migrate:(NSError **)error {
    __block NSError *err = nil;
    __block BOOL ret = NO;
    [self inTransactionWithBlock:^(FMDatabase *db, BOOL *rollback) {
        ret = [self migrate:db error:&err];
        return;
    }];
    if (!ret) {
        *error = err;
    }
    return ret;
}

- (void)close {
    [self.dbQueue close];
    self.dbQueue = nil;
    self.db = nil;
}


@end
