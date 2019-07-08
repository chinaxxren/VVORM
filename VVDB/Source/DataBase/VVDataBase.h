//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VVMigration.h"
#import "VVConditionModel.h"
#import "VVMigration.h"

@class FMDatabaseQueue;
@class FMDatabase;

@interface VVDataBase : VVMigration

+ (instancetype)openWithPath:(NSString *)path error:(NSError **)error;

- (void)inTransaction:(void (^)(VVDataBase *dataBase, BOOL *rollback))block;

- (BOOL)saveObject:(NSObject *)object;

- (BOOL)saveObject:(NSObject *)object error:(NSError **)error;

- (BOOL)saveObjects:(NSArray *)objects;

- (BOOL)saveObjects:(NSArray *)objects error:(NSError **)error;

- (BOOL)deleteObject:(NSObject *)object;

- (BOOL)deleteObject:(NSObject *)object error:(NSError **)error;

- (BOOL)deleteObjects:(NSArray *)objects;

- (BOOL)deleteObjects:(NSArray *)objects error:(NSError **)error;

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition;

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (id)refreshObject:(NSObject *)object;

- (id)refreshObject:(NSObject *)object error:(NSError **)error;

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition;

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (NSMutableArray *)fetchReferencingObjectsTo:(NSObject *)object;

- (NSMutableArray *)fetchReferencingObjectsTo:(NSObject *)object error:(NSError **)error;

// 获取个数
- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (NSNumber *)referencedCount:(NSObject *)object;

- (NSNumber *)referencedCount:(NSObject *)object error:(NSError **)error;

- (NSNumber *)existsObject:(NSObject *)object;

- (NSNumber *)existsObject:(NSObject *)object error:(NSError **)error;

// 获取最小值
- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

// 获取最大值
- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition;

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition error:(NSError **)error;

- (BOOL)registerClass:(Class)clazz;

- (BOOL)registerClass:(Class)clazz error:(NSError **)error;

- (BOOL)unRegisterClass:(Class)clazz;

- (BOOL)unRegisterClass:(Class)clazz error:(NSError **)error;

- (BOOL)migrate:(NSError **)error;

- (void)close;

@end

@interface VVDataBase (Additional)

@property(nonatomic, readonly) FMDatabaseQueue *dbQueue;

- (void)transactionDidBegin:(FMDatabase *)db;

- (void)transactionDidEnd:(FMDatabase *)db;

- (NSMutableArray *)fetchObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy error:(NSError **)error;

- (NSMutableArray *)fetchObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters orderBy:(NSString *)orderBy offset:(NSNumber *)offset limit:(NSNumber *)limit error:(NSError **)error;

- (BOOL)deleteObjects:(Class)clazz where:(NSString *)where parameters:(NSArray *)parameters error:(NSError **)error;

@end

