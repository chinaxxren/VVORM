//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzShort.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVPropertyInfo.h"

@implementation VVClazzShort

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(short int)];
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
    return SQLITE_DATA_TYPE_INTEGER;
}

@end
