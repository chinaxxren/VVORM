//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzNSNull.h"


#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzNSNull

- (Class)superClazz {
    return [NSNull class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVDBRuntimeProperty *)attribute {
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    return [NSNull null];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_BLOB;
}

@end
