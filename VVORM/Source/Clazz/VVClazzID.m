//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzID.h"

#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVSQLiteColumnModel.h"
#import "VVPropertyInfo.h"

@implementation VVClazzID

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

- (NSArray *)sqliteColumnsWithAttribute:(VVPropertyInfo *)attribute {
    VVSQLiteColumnModel *value = [[VVSQLiteColumnModel alloc] init];
    value.columnName = attribute.columnName;
    value.dataTypeName = SQLITE_DATA_TYPE_NONE;

    VVSQLiteColumnModel *attributeType = [[VVSQLiteColumnModel alloc] init];
    attributeType.columnName = [NSString stringWithFormat:@"%@_attributeType", attribute.columnName];
    attributeType.dataTypeName = SQLITE_DATA_TYPE_TEXT;

    return @[value, attributeType];
}

- (NSArray *)storeValuesWithValue:(NSObject *)value attribute:(VVPropertyInfo *)attribute {
    NSString *attributeType = nil;
    if (value) {
        VVClazz *osclazz = [VVClazz vvclazzWithClazz:[value class]];
        NSArray *storeValue = [osclazz storeValuesWithValue:value attribute:attribute];
        attributeType = osclazz.attributeType;
        NSMutableArray *storeValues = [NSMutableArray arrayWithArray:storeValue];
        if (storeValues.count == 1) {
            return @[storeValues[0], attributeType];
        }
    }

    return @[[NSNull null], [NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVPropertyInfo *)attribute {
    NSString *attributeTypeColumnName = [NSString stringWithFormat:@"%@_attributeType", attribute.columnName];
    NSString *attributeType = [resultSet stringForColumn:attributeTypeColumnName];
    Class clazz = NSClassFromString(attributeType);
    if (clazz) {
        NSObject *value = [resultSet objectForColumn:attribute.columnName];
        if (value) {
            VVClazz *osclazz = [VVClazz vvclazzWithClazz:clazz];
            if (osclazz.isSimpleValueClazz) {
                NSObject *value = [osclazz valueWithResultSet:resultSet attribute:attribute];
                return value;
            }
        }
    }

    return nil;
}

@end
