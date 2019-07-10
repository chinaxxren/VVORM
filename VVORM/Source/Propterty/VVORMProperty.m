//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "VVORMProperty.h"

#import "VVClazz.h"
#import "VVORMClass.h"
#import "VVNameBuilder.h"
#import "VVQueryBuilder.h"
#import "VVProperty.h"
#import "VVPropertyEncoding.h"
#import "VVSQLiteColumnModel.h"
#import "VVPropertyType.h"


@implementation VVORMProperty

+ (instancetype)propertyWithBZProperty:(VVProperty *)bzproperty ormClass:(VVORMClass *)ormClass nameBuilder:(VVNameBuilder *)nameBuilder {
    return [[self alloc] initWithBZProperty:bzproperty ormClass:ormClass nameBuilder:nameBuilder];
}

- (instancetype)initWithBZProperty:(VVProperty *)bzproperty ormClass:(VVORMClass *)ormClass nameBuilder:(VVNameBuilder *)nameBuilder {
    if (self = [super init]) {
        [self setupWithBZProperty:bzproperty ormClass:ormClass nameBuilder:nameBuilder];
    }
    return self;
}

- (void)setupWithBZProperty:(VVProperty *)bzproperty ormClass:(VVORMClass *)ormClass nameBuilder:(VVNameBuilder *)nameBuilder {
    BOOL isPrimitive = NO;
    BOOL isStructure = NO;
    BOOL isObject = NO;
    NSString *structureName = nil;

    // name
    self.name = bzproperty.name;
    self.tableName = ormClass.tableName;

    // data type
    if (bzproperty.propertyEncoding.isObject) {
        self.clazz = bzproperty.clazz;
        self.clazzName = NSStringFromClass(bzproperty.clazz);
        self.isValid = YES;
        isObject = YES;
        isStructure = NO;
        isPrimitive = NO;
    } else if (bzproperty.propertyEncoding.isStructure) {
        self.isValid = YES;
        isObject = NO;
        isStructure = YES;
        isPrimitive = NO;
    } else if (bzproperty.propertyEncoding) {
        if ([self isPrimitiveWithBZPropertyEncoding:bzproperty.propertyEncoding]) {
            self.isValid = YES;
            isObject = NO;
            isStructure = NO;
            isPrimitive = YES;
        } else {
            self.isValid = NO;
            isObject = NO;
            isStructure = NO;
            isPrimitive = NO;
        }
    }

    // attribute options
    self.identicalAttribute = [self boolWithProtocol:@protocol(VVIdenticalAttribute) bzproperty:bzproperty];
    self.ignoreAttribute = [self boolWithProtocol:@protocol(VVIgnoreAttribute) bzproperty:bzproperty];
    self.weakReferenceAttribute = [self boolWithProtocol:@protocol(VVWeakReferenceAttribute) bzproperty:bzproperty];
    self.notUpdateIfValueIsNullAttribute = [self boolWithProtocol:@protocol(VVNotUpdateIfValueIsNullAttribute) bzproperty:bzproperty];
    self.serializableAttribute = [self boolWithProtocol:@protocol(VVSerializableAttribute) bzproperty:bzproperty];
    self.fetchOnRefreshingAttribute = [self boolWithProtocol:@protocol(VVFetchOnRefreshingAttribute) bzproperty:bzproperty];
    self.onceUpdateAttribute = [self boolWithProtocol:@protocol(VVOnceUpdateAttribute) bzproperty:bzproperty];

    if ([ormClass.clazz conformsToProtocol:@protocol(VVModelInterface)]) {

        Class clazz = ormClass.clazz;
        if ([clazz respondsToSelector:@selector(attributeIsVVIdenticalAttribute:)]) {
            self.identicalAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVIdenticalAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVIgnoreAttribute:)]) {
            self.ignoreAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVIgnoreAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVWeakReferenceAttribute:)]) {
            self.weakReferenceAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVWeakReferenceAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVNotUpdateIfValueIsNullAttribute:)]) {
            self.notUpdateIfValueIsNullAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVNotUpdateIfValueIsNullAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVSerializableAttribute:)]) {
            self.serializableAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVSerializableAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVFetchOnRefreshingAttribute:)]) {
            self.fetchOnRefreshingAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVFetchOnRefreshingAttribute:) withObject:self.name];
        }
        if ([clazz respondsToSelector:@selector(attributeIsVVOnceUpdateAttribute:)]) {
            self.onceUpdateAttribute = (BOOL) [clazz performSelector:@selector(attributeIsVVOnceUpdateAttribute:) withObject:self.name];
        }
    }

    // weak property will be weak reference attribute
    if (bzproperty.propertyType.isWeakReference) {
        self.weakReferenceAttribute = YES;
    }

    // structureName
    if (isStructure) {
        structureName = [self structureNameWithAttributes:bzproperty.attributes];
    }

    // clazz
    if (self.serializableAttribute) {
        self.vvclazz = [VVClazz vvclazzWithPrimitiveEncodingCode:@"Serialize"];
    } else if (isStructure) {
        self.vvclazz = [VVClazz vvclazzWithStructureName:structureName];
    } else if (isPrimitive) {
        self.vvclazz = [VVClazz vvclazzWithPrimitiveEncodingCode:bzproperty.propertyEncoding.code];
    } else if (isObject) {
        self.vvclazz = [VVClazz vvclazzWithClazz:self.clazz];
    }
    self.isSimpleValueClazz = self.vvclazz.isSimpleValueClazz;
    self.isArrayClazz = self.vvclazz.isArrayClazz;
    self.isObjectClazz = self.vvclazz.isObjectClazz;
    self.isRelationshipClazz = self.vvclazz.isRelationshipClazz;
    self.isPrimaryClazz = self.vvclazz.isPrimaryClazz;
    self.attributeType = self.vvclazz.attributeType;

    // identicalAttribute
    if (!self.isPrimaryClazz) {
        self.identicalAttribute = NO;
    }

    // relationship attribute
    if (self.serializableAttribute) {
        self.isRelationshipClazz = NO;
    }

    // fetchOnRefreshingAttribute
    if (self.fetchOnRefreshingAttribute) {
        self.notUpdateIfValueIsNullAttribute = YES;
    }

    // sqlite
    self.columnName = [nameBuilder columnName:bzproperty.name clazz:ormClass.clazz];
    self.sqliteColumns = [self.vvclazz sqliteColumnsWithAttribute:self];
}

- (BOOL)isPrimitiveWithBZPropertyEncoding:(VVPropertyEncoding *)encoding {
    if (encoding.isChar) return YES;
    else if (encoding.isInt) return YES;
    else if (encoding.isShort) return YES;
    else if (encoding.isLong) return YES;
    else if (encoding.isLongLong) return YES;
    else if (encoding.isUnsignedChar) return YES;
    else if (encoding.isUnsignedInt) return YES;
    else if (encoding.isUnsignedShort) return YES;
    else if (encoding.isUnsignedLong) return YES;
    else if (encoding.isUnsignedLongLong) return YES;
    else if (encoding.isFloat) return YES;
    else if (encoding.isDouble) return YES;
    else if (encoding.isBool) return YES;
    return NO;
}


- (BOOL)boolWithProtocol:(Protocol *)protocol bzproperty:(VVProperty *)bzproperty {
    NSString *name = NSStringFromProtocol(protocol);
    name = [NSString stringWithFormat:@"<%@>", name];
    NSRange range = [bzproperty.attributes rangeOfString:name];
    return range.location != NSNotFound;
}

- (NSString *)structureNameWithAttributes:(NSString *)attributes {
    NSString *structureName = nil;
    NSArray *attributeList = [attributes componentsSeparatedByString:@","];
    NSString *firstAttribute = [attributeList firstObject];
    if (firstAttribute.length > 3) {
        NSString *name = [firstAttribute substringWithRange:NSMakeRange(2, firstAttribute.length - 3)];
        NSArray *names = [name componentsSeparatedByString:@"="];
        structureName = names.firstObject;
        if ([structureName isEqualToString:@"?"] && names.count > 1) {
            structureName = names[1];
        }
    }
    return structureName;
}

#pragma mark statement

- (NSString *)alterTableAddColumnStatement:(VVSQLiteColumnModel *)sqliteColumn {
    return [VVQueryBuilder alterTableAddColumnStatement:self.tableName sqliteColumn:sqliteColumn];
}


#pragma mark mapping methods

- (NSArray *)storeValuesWithObject:(NSObject *)object {
    return [self.vvclazz storeValuesWithValue:[object valueForKey:self.name] attribute:self];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet {
    return [self.vvclazz valueWithResultSet:resultSet attribute:self];
}

#pragma mark

+ (NSString *)VVTableName {
    return @"__VVORMProperty__";
}

@end
