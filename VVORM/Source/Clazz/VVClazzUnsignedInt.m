//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzUnsignedInt.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVORMProperty.h"

@implementation VVClazzUnsignedInt

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(unsigned int)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVORMProperty *)attribute {
    return @[value];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVORMProperty *)attribute {
    unsigned long long int value = [resultSet unsignedLongLongIntForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_INTEGER;
}

@end
