//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "VVModelInterface.h"

@class VVConditionModel;
@class VVRuntime;
@class VVNameBuilder;
@class VVClazz;
@class VVSQLiteColumnModel;
@class FMResultSet;
@class VVProperty;

@interface VVRuntimeProperty : NSObject <VVModelInterface>

+ (instancetype)propertyWithBZProperty:(VVProperty *)bzproperty runtime:(VVRuntime *)runtime nameBuilder:(VVNameBuilder *)nameBuilder;

// sqlite information
@property(nonatomic, copy) NSString *tableName;
@property(nonatomic, copy) NSString *columnName;
@property(nonatomic, strong) NSArray <VVSerializableAttribute> *sqliteColumns;

// name informations
@property(nonatomic, copy) NSString *clazzName;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *attributeType;

// class type information
@property(nonatomic, assign) Class clazz;
@property(nonatomic, assign) BOOL isSimpleValueClazz;
@property(nonatomic, assign) BOOL isArrayClazz;
@property(nonatomic, assign) BOOL isObjectClazz;
@property(nonatomic, assign) BOOL isPrimaryClazz;
@property(nonatomic, assign) BOOL isValid;

// attribute informations
@property(nonatomic, assign) BOOL identicalAttribute;
@property(nonatomic, assign) BOOL ignoreAttribute;
@property(nonatomic, assign) BOOL weakReferenceAttribute;
@property(nonatomic, assign) BOOL notUpdateIfValueIsNullAttribute;
@property(nonatomic, assign) BOOL serializableAttribute;
@property(nonatomic, assign) BOOL fetchOnRefreshingAttribute;
@property(nonatomic, assign) BOOL onceUpdateAttribute;

// data type information
@property(nonatomic, assign) BOOL isRelationshipClazz;

//
@property(nonatomic, strong) VVClazz <VVSerializableAttribute> *vvclazz;

// mapper methods
- (NSArray *)storeValuesWithObject:(NSObject *)object;

- (id)valueWithResultSet:(FMResultSet *)resultSet;

// statement methods
- (NSString *)alterTableAddColumnStatement:(VVSQLiteColumnModel *)sqliteColumn;

@end
