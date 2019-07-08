//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSNumber.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"

@implementation VVClazzNSNumber

- (Class)superClazz {
    return [NSNumber class];
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

- (NSArray *)storeValuesWithValue:(NSNumber *)value attribute:(VVRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    NSNumber *value = [resultSet objectForColumn:attribute.columnName];
    if ([[value class] isSubclassOfClass:[NSNumber class]]) {
        return value;
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_INTEGER;
}

@end
