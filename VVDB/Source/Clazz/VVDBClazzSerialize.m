//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzSerialize.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzSerialize

- (Class)superClazz {
    return NULL;
}

- (NSString *)attributeType {
    return @"Serialize";
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSObject *)value attribute:(VVDBRuntimeProperty *)attribute {
    if ([value conformsToProtocol:@protocol(NSCoding)]) {
        return @[[NSKeyedArchiver archivedDataWithRootObject:value]];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSData *value = [resultSet dataForColumn:attribute.columnName];
    if (value) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:value];
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_BLOB;
}

@end
