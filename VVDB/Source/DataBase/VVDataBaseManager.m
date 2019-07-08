//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDataBaseManager.h"

#import "VVDataBase.h"

@interface VVDataBaseManager ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, VVDataBase *> *dbDict;

@end

@implementation VVDataBaseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dbDict = [NSMutableDictionary<NSString *, VVDataBase *> new];
    }

    return self;
}

+ (instancetype)share {
    static VVDataBaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [VVDataBaseManager new];
    });

    return manager;
}

- (VVDataBase *)getDataBase:(NSString *)name {
    @synchronized (self) {
        if (!name) {
            return nil;
        }

        VVDataBase *dataBase = self.dbDict[name];
        if (dataBase) {
            return dataBase;
        }

        NSString *path = [VVDataBaseManager dataBasePathWithName:name];
        if (!path) {
            return nil;
        }

        dataBase = [VVDataBaseManager dataBaseWithPath:path];
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

+ (NSString *)dataBasePathWithName:(NSString *)name {
    NSString *direct = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [direct stringByAppendingPathComponent:@"db"];
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

+ (VVDataBase *)dataBaseWithPath:(NSString *)dbPath {
    NSError *error;
    VVDataBase *dataBase = [VVDataBase openWithPath:dbPath error:&error];
    if (error) {
        NSLog(@"database error %@", error);
        return nil;
    }

    return dataBase;
}

+ (VVDataBase *)getDataBase:(NSString *)name {
    return [[VVDataBaseManager share] getDataBase:name];
}

@end