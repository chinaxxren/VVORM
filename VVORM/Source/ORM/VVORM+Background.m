//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVORM+Background.h"

@implementation VVORM (Background)

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

- (void)deleteObjectsInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSError *error))completionBlock {
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

- (void)fetchObjectsInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSArray *objects, NSError *error))completionBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSError *error = nil;
        NSArray *objects = [self findObjects:clazz condition:condition error:&error];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            completionBlock(objects, error);
        }];
    }];
}

- (void)countInBackground:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)maxInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)minInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)sumInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)totalInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)avgInBackground:(NSString *)attributeName class:(Class)clazz condition:(VVConditionModel *)condition completionBlock:(void (^)(NSNumber *value, NSError *error))completionBlock {
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

- (void)inTransactionInBackground:(void (^)(VVORM *dataBase, BOOL *rollback))block {
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
