//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSObject.h"

#import "VVSqliteConst.h"
#import "VVPropertyInfo.h"

@implementation VVClazzNSObject

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

- (NSArray *)storeValuesWithValue:(NSObject *)value attribute:(VVPropertyInfo *)attribute {
    return @[@"NSObject"];
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}

@end
