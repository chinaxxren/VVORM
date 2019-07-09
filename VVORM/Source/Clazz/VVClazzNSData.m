//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSData.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"

@implementation VVClazzNSData

- (Class)superClazz {
    return [NSData class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSData *)value attribute:(VVRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    NSData *value = [resultSet dataForColumn:attribute.columnName];
    return value;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_BLOB;
}

@end
