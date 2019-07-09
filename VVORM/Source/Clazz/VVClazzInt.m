//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzInt.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVORMProperty.h"

@implementation VVClazzInt

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(int)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVORMProperty *)attribute {
    if (value) {
        return @[value];
    } else {
        return @[];
    }
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVORMProperty *)attribute {
    int value = [resultSet intForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_NUMERIC;
}

@end
