//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSArray.h"
#import "VVSqliteConst.h"

@implementation VVClazzNSArray

- (NSEnumerator *)objectEnumeratorWithObject:(NSArray *)object {
    return [object objectEnumerator];
}

- (NSArray *)keysWithObject:(id)object {
    return nil;
}

- (id)objectWithObjects:(NSArray *)objects keys:(NSArray *)keys initializingOptions:(NSString *)initializingOptions {
    return [NSArray arrayWithArray:objects];
}

- (Class)superClazz {
    return [NSArray class];
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
    return @[@"NSArray"];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}

@end
