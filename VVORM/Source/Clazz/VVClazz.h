//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@class VVPropertyInfo;

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

- (id)objectWithClazz:(Class)clazz;

- (NSArray *)storeValuesWithValue:(id)value attribute:(VVPropertyInfo *)attribute;

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVPropertyInfo *)attribute;

- (NSString *)sqliteDataTypeName;

- (NSArray *)sqliteColumnsWithAttribute:(VVPropertyInfo *)attribute;

- (NSArray *)requiredPropertyList;

@end


@interface VVClazz : NSObject <VVStoreClazzProtocol>

+ (VVClazz *)vvclazzWithClazz:(Class)clazz;

+ (VVClazz *)vvclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode;

+ (VVClazz *)vvclazzWithStructureName:(NSString *)StructureName;

+ (void)addClazz:(Class)clazz;

@end
