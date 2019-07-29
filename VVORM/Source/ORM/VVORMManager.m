//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVORMManager.h"

#import "VVORM.h"

#define DEFAULT_DB_DIR @"db"

@interface VVORMManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, VVORM *> *dbDict;

@end

@implementation VVORMManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbDict = [NSMutableDictionary<NSString *, VVORM *> new];
    }

    return self;
}

+ (instancetype)share {
    static VVORMManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [VVORMManager new];
    });

    return manager;
}

- (VVORM *)getORM:(NSString *)name {
    return [[self class] getORM:name dir:DEFAULT_DB_DIR];
}

- (VVORM *)getORM:(NSString *)name dir:(NSString *)dir {
    @synchronized (self) {
        if (!name) {
            return nil;
        }

        VVORM *dataBase = self.dbDict[name];
        if (dataBase) {
            return dataBase;
        }

        NSString *path = [VVORMManager ormPathWithName:name dir:dir];
        if (!path) {
            return nil;
        }

        dataBase = [VVORMManager ormWithPath:path];
        if (!dataBase) {
            return nil;
        }
        self.dbDict[name] = dataBase;
#if DEBUG
        NSLog(@"db path %@", path);
#endif
        return dataBase;
    }
}

+ (NSString *)ormPathWithName:(NSString *)name {
    return [[self class] ormPathWithName:name dir:DEFAULT_DB_DIR];
}

+ (NSString *)ormPathWithName:(NSString *)name dir:(NSString *)dir {
    NSString *direct = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [direct stringByAppendingPathComponent:dir];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:direct]) {
        NSError *error;
        [defaultManager createDirectoryAtPath:direct withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"database error %@", error);
            return nil;
        }
    }

    NSString *dbPath = [direct stringByAppendingFormat:@"/%@.sqlite", name];
    return dbPath;
}

+ (VVORM *)ormWithPath:(NSString *)dbPath {
    NSError *error;
    VVORM *dataBase = [VVORM openWithPath:dbPath error:&error];
    if (error) {
        NSLog(@"orm error %@", error);
        return nil;
    }

    return dataBase;
}

+ (VVORM *)getORM:(NSString *)name {
    return [[VVORMManager share] getORM:name];
}

+ (VVORM *)getORM:(NSString *)name dir:(NSString *)dir {
    return [[VVORMManager share] getORM:name dir:dir];
}

@end
