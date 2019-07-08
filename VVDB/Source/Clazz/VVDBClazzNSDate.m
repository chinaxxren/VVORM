//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzNSDate.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzNSDate

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

- (NSArray *)storeValuesWithValue:(NSDate *)value attribute:(VVDBRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSDate *value = [resultSet dateForColumn:attribute.columnName];
    return value;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_DATETIME;
}

@end

