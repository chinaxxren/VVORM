//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDataBase+Background.h"

@implementation VVDataBase (Background)

- (void)saveObjectInBackground:(NSObject *)object completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self saveObject:object error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)saveObjectsInBackground:(NSArray *)objects completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self saveObjects:objects error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)deleteObjectInBackground:(NSObject *)object completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self deleteObject:object error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)deleteObjectsInBackground:(NSArray *)objects completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self deleteObjects:objects error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)deleteObjectsInBackground:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self deleteObjects:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)refreshObjectInBackground:(NSObject *)object completionBlock:(void (^)(id object, NSError *error))completionBlock; {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSObject *refreshedObject = [self refreshObject:object error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(refreshedObject, error);
        }];
    }];
}

- (void)fetchObjectsInBackground:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSArray *objects = [self fetchObjects:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(objects, error);
        }];
    }];
}

- (void)fetchReferencingObjectsToInBackground:(NSObject *)object completionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSArray *objects = [self fetchReferencingObjectsTo:object error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(objects, error);
        }];
    }];
}

- (void)referencedCountInBackground:(NSObject *)object completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self referencedCount:object error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)countInBackground:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self count:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)maxInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self max:attributeName class:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)minInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self min:attributeName class:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)sumInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self sum:attributeName class:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)totalInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self total:attributeName class:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)avgInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVDBConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSNumber *value = [self avg:attributeName class:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(value, error);
        }];
    }];
}

- (void)inTransactionInBackground:(void (^)(VVDataBase *os, BOOL *rollback))block {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [self inTransaction:block];
    }];
}

- (void)migrateInBackground:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self migrate:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)registerClassInBackground:(Class)clazz completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self registerClass:clazz error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}

- (void)unRegisterClassInBackground:(Class)clazz completionBlock:(void (^)(NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        [self unRegisterClass:clazz error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(error);
        }];
    }];
}


@end
