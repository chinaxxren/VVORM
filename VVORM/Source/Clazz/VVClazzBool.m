//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzBool.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVPropertyInfo.h"

@implementation VVClazzBool

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(bool)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVPropertyInfo *)attribute {
    return @[value];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVPropertyInfo *)attribute {
    int value = [resultSet intForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_NUMERIC;
}

@end
