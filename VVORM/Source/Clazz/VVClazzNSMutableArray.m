//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSMutableArray.h"

#import <FMDB/FMResultSet.h>

#import "VVORMProperty.h"
#import "VVSqliteConst.h"

@implementation VVClazzNSMutableArray

- (NSEnumerator *)objectEnumeratorWithObject:(NSMutableArray *)object {
    return [object objectEnumerator];
}

- (NSArray *)keysWithObject:(id)object {
    return nil;
}

- (id)objectWithObjects:(NSArray *)objects keys:(NSArray *)keys initializingOptions:(NSString *)initializingOptions {
    return [NSMutableArray arrayWithArray:objects];
}

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

- (NSArray *)storeValuesWithValue:(NSArray *)value attribute:(VVORMProperty *)attribute {
    return @[@"__VVORMRelationship__"];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}


@end

