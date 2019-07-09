//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzChar.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVORMProperty.h"

@implementation VVClazzChar

- (NSString *)attributeType {
    return [NSString stringWithFormat:@"%s", @encode(char)];
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVORMProperty *)attribute {
    return @[@([value intValue])];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVORMProperty *)attribute {
    int value = [resultSet intForColumn:attribute.columnName];
    return @(value);
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_INTEGER;
}

@end
