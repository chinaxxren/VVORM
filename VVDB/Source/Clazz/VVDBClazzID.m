//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzID.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVSQLiteColumnModel.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzID

- (Class)superClazz {
    return NULL;
}

- (NSString *)attributeType {
    return nil;
}

- (BOOL)isObjectClazz {
    return YES;
}

- (BOOL)isRelationshipClazz {
    return YES;
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)sqliteColumnsWithAttribute:(VVDBRuntimeProperty *)attribute {
    VVSQLiteColumnModel *value = [[VVSQLiteColumnModel alloc] init];
    value.columnName = attribute.columnName;
    value.dataTypeName = SQLITE_DATA_TYPE_NONE;

    VVSQLiteColumnModel *attributeType = [[VVSQLiteColumnModel alloc] init];
    attributeType.columnName = [NSString stringWithFormat:@"%@_attributeType", attribute.columnName];
    attributeType.dataTypeName = SQLITE_DATA_TYPE_TEXT;

    return @[value, attributeType];
}

- (NSArray *)storeValuesWithValue:(NSObject *)value attribute:(VVDBRuntimeProperty *)attribute {
    NSString *attributeType = nil;
    if (value) {
        VVDBClazz *osclazz = [VVDBClazz vvclazzWithClazz:[value class]];
        NSArray *storeValue = [osclazz storeValuesWithValue:value attribute:attribute];
        attributeType = osclazz.attributeType;
        NSMutableArray *storeValues = [NSMutableArray arrayWithArray:storeValue];
        if (storeValues.count == 1) {
            return @[storeValues[0], attributeType];
        }
    }

    return @[[NSNull null], [NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSString *attributeTypeColumnName = [NSString stringWithFormat:@"%@_attributeType", attribute.columnName];
    NSString *attributeType = [resultSet stringForColumn:attributeTypeColumnName];
    Class clazz = NSClassFromString(attributeType);
    if (clazz) {
        NSObject *value = [resultSet objectForColumnName:attribute.columnName];
        if (value) {
            VVDBClazz *osclazz = [VVDBClazz vvclazzWithClazz:clazz];
            if (osclazz.isSimpleValueClazz) {
                NSObject *value = [osclazz valueWithResultSet:resultSet attribute:attribute];
                return value;
            }
        }
    }

    return nil;
}

@end
