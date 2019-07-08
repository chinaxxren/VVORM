//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class VVDBRuntimeProperty;

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

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVDBRuntimeProperty *)attribute;

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute;

- (NSString *)sqliteDataTypeName;

- (NSArray *)sqliteColumnsWithAttribute:(VVDBRuntimeProperty *)attribute;

- (NSArray *)requiredPropertyList;

@end


@interface VVDBClazz : NSObject <VVStoreClazzProtocol>

+ (VVDBClazz *)vvclazzWithClazz:(Class)clazz;

+ (VVDBClazz *)vvclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode;

+ (VVDBClazz *)vvclazzWithStructureName:(NSString *)StructureName;

+ (void)addClazz:(Class)clazz;

@end
