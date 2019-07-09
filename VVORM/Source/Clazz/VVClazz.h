//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class VVORMProperty;

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

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVORMProperty *)attribute;

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVORMProperty *)attribute;

- (NSString *)sqliteDataTypeName;

- (NSArray *)sqliteColumnsWithAttribute:(VVORMProperty *)attribute;

- (NSArray *)requiredPropertyList;

@end


@interface VVClazz : NSObject <VVStoreClazzProtocol>

+ (VVClazz *)vvclazzWithClazz:(Class)clazz;

+ (VVClazz *)vvclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode;

+ (VVClazz *)vvclazzWithStructureName:(NSString *)StructureName;

+ (void)addClazz:(Class)clazz;

@end
