//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSDate.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"

@implementation VVClazzNSDate

- (Class)superClazz {
    return [NSDate class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (BOOL)isPrimaryClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSDate *)value attribute:(VVRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    NSDate *value = [resultSet dateForColumn:attribute.columnName];
    return value;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_DATETIME;
}

@end

