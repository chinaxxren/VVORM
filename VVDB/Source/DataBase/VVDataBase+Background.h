//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVDataBase.h"

@interface VVDataBase (Background)

- (void)inTransactionInBackground:(void (^)(VVDataBase *dataBase, BOOL *rollback))block;

- (void)saveObjectInBackground:(NSObject *)object completionBlock:(void (^)(NSError *error))completionBlock;

- (void)saveObjectsInBackground:(NSArray *)objects completionBlock:(void (^)(NSError *error))completionBlock;

- (void)deleteObjectInBackground:(NSObject *)object completionBlock:(void (^)(NSError *error))completionBlock;

- (void)deleteObjectsInBackground:(NSArray *)objects completionBlock:(void (^)(NSError *error))completionBlock;

- (void)deleteObjectsInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSError *error))completionBlock;

- (void)refreshObjectInBackground:(NSObject *)object completionBlock:(void (^)(id object, NSError *error))completionBlock;

- (void)fetchObjectsInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock;

- (void)fetchReferencingObjectsToInBackground:(NSObject *)object completionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock;

- (void)countInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)referencedCountInBackground:(NSObject *)object completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)maxInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)minInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)sumInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)totalInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)avgInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock;

- (void)migrateInBackground:(void (^)(NSError *error))completionBlock;

- (void)registerClassInBackground:(Class)clazz completionBlock:(void (^)(NSError *error))completionBlock;

- (void)unRegisterClassInBackground:(Class)clazz completionBlock:(void (^)(NSError *error))completionBlock;

@end