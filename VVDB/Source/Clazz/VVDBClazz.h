//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVStoreRuntimeProperty;
@class FMResultSet;

@protocol VVStoreClazzProtocol <NSObject>

@optional

- (Class)superClazz;

- (BOOL)isSimpleValueClazz;

- (BOOL)isArrayClazz;

- (BOOL)isObjectClazz;

- (BOOL)isRelationshipClazz;

- (BOOL)isPrimaryClazz;

- (BOOL)isSubClazz:(Class)clazz;

- (NSString *)attributeType;

- (id)objectWithObjects:(NSArray *)objects keys:(NSArray *)keys initializingOptions:(NSString *)initializingOptions;

- (id)objectWithClazz:(Class)clazz;

- (NSEnumerator *)objectEnumeratorWithObject:(id)object;

- (NSArray *)keysWithObject:(id)object;

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVStoreRuntimeProperty *)attribute;

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVStoreRuntimeProperty *)attribute;

- (NSString *)sqliteDataTypeName;

- (NSArray *)sqliteColumnsWithAttribute:(VVStoreRuntimeProperty *)attribute;

- (NSArray *)requiredPropertyList;

@end


@interface VVStoreClazz : NSObject <VVStoreClazzProtocol>

+ (VVStoreClazz *)osclazzWithClazz:(Class)clazz;

+ (VVStoreClazz *)osclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode;

+ (VVStoreClazz *)osclazzWithStructureName:(NSString *)StructureName;

+ (void)addClazz:(Class)clazz;

@end
