//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSURL.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"


@implementation VVClazzNSURL

- (Class)superClazz {
    return [NSURL class];
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

- (NSArray *)storeValuesWithValue:(NSURL *)value attribute:(VVRuntimeProperty *)attribute {
    if (value) {
        return @[[value absoluteString]];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    NSString *value = [resultSet stringForColumn:attribute.columnName];
    if (value) {
        return [NSURL URLWithString:value];
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}

@end
