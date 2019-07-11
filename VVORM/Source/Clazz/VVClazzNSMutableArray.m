//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSMutableArray.h"

#import <FMDB/FMResultSet.h>

#import "VVPropertyInfo.h"
#import "VVSqliteConst.h"

@implementation VVClazzNSMutableArray

- (Class)superClazz {
    return [NSMutableArray class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isArrayClazz {
    return YES;
}

- (BOOL)isRelationshipClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSArray *)value attribute:(VVPropertyInfo *)attribute {
    return @[@"NSMutableArray"];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}


@end

