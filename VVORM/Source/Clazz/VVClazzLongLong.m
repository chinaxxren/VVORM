//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzLongLong.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"

@implementation VVClazzLongLong

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(long long)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVRuntimeProperty *)attribute {
    return @[value];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    long long value = [resultSet longLongIntForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_INTEGER;
}

@end
