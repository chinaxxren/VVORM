//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzFloat.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzFloat

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(float)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVDBRuntimeProperty *)attribute {
    return @[value];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    double value = [resultSet doubleForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_REAL;
}

@end
