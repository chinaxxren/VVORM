//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDataBaseManager.h"

#import "VVDataBase.h"
#import "VVCurrentDatabase.h"


@implementation VVDataBaseManager

+ (VVDataBase *)loadDataBaseWithPath:(NSString *)dbPath {
    NSError *error;
    VVDataBase *dataBase = [VVDataBase openWithPath:dbPath error:&error];

#if DEBUG
    NSLog(@"database error %@", error);
#endif

    return dataBase;
}

+ (NSString *)dataBasePathWithName:(NSString *)name {
    NSString *direct = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [direct stringByAppendingPathComponent:@"db"];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:direct]) {
        [defaultManager createDirectoryAtPath:direct withIntermediateDirectories:YES attributes:nil error:NULL];
    }

    NSString *dbPath = [direct stringByAppendingFormat:@"/%@.sqlite", name];
    return dbPath;
}

- (void)loadDataBase:(NSString *)name {
    NSString *path = [VVDataBaseManager dataBasePathWithName:name];
    VVDataBase *dataBase = [VVDataBaseManager loadDataBaseWithPath:path];
    [VVCurrentDatabase setupWithDataBase:dataBase];
}

@end