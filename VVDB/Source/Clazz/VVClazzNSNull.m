//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSNull.h"


#import <FMDB/FMResultSet.h>

#import "VVSqliteConst.h"
#import "VVRuntimeProperty.h"

@implementation VVClazzNSNull

- (Class)superClazz {
    return [NSNull class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVRuntimeProperty *)attribute {
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVRuntimeProperty *)attribute {
    return [NSNull null];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_BLOB;
}

@end
