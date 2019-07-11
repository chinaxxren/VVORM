//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSObject.h"

#import "VVSqliteConst.h"
#import "VVORMProperty.h"

@implementation VVClazzNSObject

- (NSEnumerator *)objectEnumeratorWithObject:(NSArray *)object {
    NSArray *array = @[object];
    return [array objectEnumerator];
}

- (NSArray *)keysWithObject:(id)object {
    return nil;
}

- (id)objectWithClazz:(Class)clazz {
    return [[clazz alloc] init];
}

- (Class)superClazz {
    return [NSObject class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isObjectClazz {
    return YES;
}

- (BOOL)isRelationshipClazz {
    return YES;
}

- (void)setValue:(id)value object:(id)object forKey:(NSString *)key {
    [object setValue:value forKeyPath:key];
}

- (NSArray *)storeValuesWithValue:(NSObject *)value attribute:(VVORMProperty *)attribute {
    return @[@"NSObject"];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}

@end
