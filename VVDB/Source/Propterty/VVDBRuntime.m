//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVStoreRuntime.h"

#import "VVDBClazz.h"
#import "VVDBNameBuilder.h"
#import "VVStoreRuntimeProperty.h"
#import "VVDBConditionModel.h"
#import "VVDBSQLiteConditionModel.h"
#import "VVDBQueryBuilder.h"
#import "VVDBReferenceModel.h"
#import "VVClassProperty.h"
#import "VVProperty.h"
#import "VVPropertyType.h"

@implementation VVStoreRuntime

- (instancetype)initWithClazz:(Class)clazz osclazz:(VVDBClazz *)osclazz nameBuilder:(VVDBNameBuilder *)nameBuilder {
    if (self = [super init]) {
        [self setupWithClazz:clazz osclazz:osclazz nameBuilder:nameBuilder];
    }
    return self;
}

- (void)setupWithClazz:(Class)clazz osclazz:(VVDBClazz *)osclazz nameBuilder:(VVDBNameBuilder *)nameBuilder {
    // clazz
    self.clazz = clazz;
    self.clazzName = NSStringFromClass(clazz);

    // mapper
    self.osclazz = osclazz;
    self.isArrayClazz = self.osclazz.isArrayClazz;
    self.isObjectClazz = self.osclazz.isObjectClazz;
    self.isSimpleValueClazz = self.osclazz.isSimpleValueClazz;
    self.isRelationshipClazz = self.osclazz.isRelationshipClazz;

    if (!self.isObjectClazz) {
        return;
    }

    // table name and column name for query builder
    self.tableName = [nameBuilder tableName:self.clazz];

    // class options
    self.fullTextSearch3 = [self.clazz conformsToProtocol:@protocol(VVFullTextSearch3)];
    self.fullTextSearch4 = [self.clazz conformsToProtocol:@protocol(VVFullTextSearch4)];
    if ([self.clazz conformsToProtocol:@protocol(VVModelInterface)]) {
        NSObject *object = [[self.clazz alloc] init];
        if ([object respondsToSelector:@selector(VVModelDidSave)]) {
            self.modelDidSave = YES;
        }
        if ([object respondsToSelector:@selector(VVModelDidDelete)]) {
            self.modelDidDelete = YES;
        }
        if ([object respondsToSelector:@selector(VVModelDidLoad)]) {
            self.modelDidLoad = YES;
        }
    }

    // attributes
    VVClassProperty *bzruntime = nil;
    if ([self.clazz conformsToProtocol:@protocol(VVIgnoreSuperClass)]) {
        bzruntime = [VVClassProperty runtimeWithClass:self.clazz superClazz:self.osclazz.superClazz];
    } else {
        bzruntime = [VVClassProperty runtimeSuperClassWithClass:self.clazz superClazz:self.osclazz.superClazz];
    }
    NSMutableArray *propertyList = [NSMutableArray array];
    NSArray *requiredPropertyListOnEachClazz = [self.osclazz requiredPropertyList];
    if (requiredPropertyListOnEachClazz) {
        [propertyList addObjectsFromArray:requiredPropertyListOnEachClazz];
    }
    for (VVProperty *property in bzruntime.propertyList) {
        NSString *from = [property.name uppercaseString];
        if (![from isEqualToString:@"ROWID"]) {
            BOOL exists = NO;
            for (VVProperty *existingProperty in propertyList) {
                NSString *to = [existingProperty.name uppercaseString];
                if ([from isEqualToString:to]) {
                    exists = YES;
                    break;
                }
            }
            if (!exists) {
                [propertyList addObject:property];
            }
        }
    }
    NSMutableArray *insertAttributes = [NSMutableArray array];
    NSMutableArray *identicalAttributes = [NSMutableArray array];
    NSMutableArray *updateAttributes = [NSMutableArray array];
    NSMutableArray *relationshipAttributes = [NSMutableArray array];
    NSMutableArray *simpleValueAttributes = [NSMutableArray array];
    for (VVProperty *property in propertyList) {
        VVStoreRuntimeProperty *objectStoreAttribute = [VVStoreRuntimeProperty propertyWithBZProperty:property runtime:self nameBuilder:nameBuilder];
        if (objectStoreAttribute.isValid) {
            if (!objectStoreAttribute.ignoreAttribute && !property.propertyType.isReadonly) {
                [insertAttributes addObject:objectStoreAttribute];
                if (objectStoreAttribute.identicalAttribute) {
                    [identicalAttributes addObject:objectStoreAttribute];
                }
                if (!objectStoreAttribute.onceUpdateAttribute) {
                    [updateAttributes addObject:objectStoreAttribute];
                }
                if (objectStoreAttribute.notUpdateIfValueIsNullAttribute) {
                    self.hasNotUpdateIfValueIsNullAttribute = YES;
                }
                if (objectStoreAttribute.isRelationshipClazz) {
                    [relationshipAttributes addObject:objectStoreAttribute];
                }
                if (objectStoreAttribute.isSimpleValueClazz) {
                    [simpleValueAttributes addObject:objectStoreAttribute];
                }
            }
        }
    }

    VVClassProperty *referenceRuntime = [VVClassProperty runtimeWithClass:[VVDBReferenceModel class]];
    VVStoreRuntimeProperty *rowidAttribute = [VVStoreRuntimeProperty propertyWithBZProperty:referenceRuntime.propertyList.firstObject runtime:self nameBuilder:nameBuilder];
    NSMutableArray *attributes = [NSMutableArray array];
    [attributes addObject:rowidAttribute];
    [attributes addObjectsFromArray:insertAttributes];
    [simpleValueAttributes addObject:rowidAttribute];

    self.rowidAttribute = rowidAttribute;
    self.attributes = [NSArray arrayWithArray:attributes];
    self.insertAttributes = [NSArray arrayWithArray:insertAttributes];
    self.updateAttributes = [NSArray arrayWithArray:updateAttributes];
    self.identificationAttributes = [NSArray arrayWithArray:identicalAttributes];
    self.relationshipAttributes = [NSArray arrayWithArray:relationshipAttributes];
    self.simpleValueAttributes = [NSArray arrayWithArray:simpleValueAttributes];

    // response
    if (self.identificationAttributes.count > 0) {
        self.hasIdentificationAttributes = YES;
    } else {
        self.hasIdentificationAttributes = NO;
    }
    if (self.relationshipAttributes.count > 0) {
        self.hasRelationshipAttributes = YES;
    } else {
        self.hasRelationshipAttributes = NO;
    }
    self.insertPerformance = [self.clazz conformsToProtocol:@protocol(VVInsertPerformance)];
    self.updatePerformance = [self.clazz conformsToProtocol:@protocol(VVUpdatePerformance)];
    self.notification = [self.clazz conformsToProtocol:@protocol(VVNotification)];
    self.cascadeNotification = [self.clazz conformsToProtocol:@protocol(VVCascadeNotification)];

    if (self.insertPerformance == NO && self.updatePerformance == NO) {
        self.insertPerformance = YES;
    }

    // query
    self.selectTemplateStatement = [VVDBQueryBuilder selectStatement:self];
    self.updateTemplateStatement = [VVDBQueryBuilder updateStatement:self];
    self.selectRowidTemplateStatement = [VVDBQueryBuilder selectRowidStatement:self];
    self.insertIntoTemplateStatement = [VVDBQueryBuilder insertIntoStatement:self];
    self.insertOrIgnoreIntoTemplateStatement = [VVDBQueryBuilder insertOrIgnoreIntoStatement:self];
    self.insertOrReplaceIntoTemplateStatement = [VVDBQueryBuilder insertOrReplaceIntoStatement:self];
    self.deleteFromTemplateStatement = [VVDBQueryBuilder deleteFromStatement:self];
    self.createTableTemplateStatement = [VVDBQueryBuilder createTableStatement:self];
    self.dropTableTemplateStatement = [VVDBQueryBuilder dropTableStatement:self];
    self.createUniqueIndexTemplateStatement = [VVDBQueryBuilder createUniqueIndexStatement:self];
    self.dropIndexTemplateStatement = [VVDBQueryBuilder dropIndexStatement:self];
    self.countTemplateStatement = [VVDBQueryBuilder countStatement:self];
    self.referencedCountTemplateStatement = [VVDBQueryBuilder referencedCountStatement:self];
    self.uniqueIndexNameTemplateStatement = [VVDBQueryBuilder uniqueIndexName:self];

}

#pragma mark statement methods

- (NSString *)uniqueIndexName {
    return self.uniqueIndexNameTemplateStatement;
}

- (NSString *)createTableStatement {
    return self.createTableTemplateStatement;
}

- (NSString *)dropTableStatement {
    return self.dropTableTemplateStatement;
}

- (NSString *)createUniqueIndexStatement {
    return self.createUniqueIndexTemplateStatement;
}

- (NSString *)dropUniqueIndexStatement {
    return self.dropIndexTemplateStatement;
}

- (NSString *)insertIntoStatement {
    return self.insertIntoTemplateStatement;
}

- (NSString *)insertOrIgnoreIntoStatement {
    return self.insertOrIgnoreIntoTemplateStatement;
}

- (NSString *)insertOrReplaceIntoStatement {
    return self.insertOrReplaceIntoTemplateStatement;
}

- (NSString *)updateStatementWithObject:(NSObject *)object condition:(VVDBConditionModel *)condition {
    if (self.hasNotUpdateIfValueIsNullAttribute) {
        NSMutableArray *attributes = [NSMutableArray array];
        for (VVStoreRuntimeProperty *attribute in self.updateAttributes) {
            NSValue *value = [object valueForKey:attribute.name];
            if (value) {
                [attributes addObject:attribute];
            }
        }
        NSMutableString *sql = [NSMutableString string];
        [sql appendString:[VVDBQueryBuilder updateStatement:self attributes:attributes]];
        [sql appendString:[VVDBQueryBuilder updateConditionStatement:condition]];
        return [NSString stringWithString:sql];
    } else {
        NSMutableString *sql = [NSMutableString string];
        [sql appendString:self.updateTemplateStatement];
        [sql appendString:[VVDBQueryBuilder updateConditionStatement:condition]];
        return [NSString stringWithString:sql];
    }
}

- (NSString *)selectStatementWithCondition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.selectTemplateStatement];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    [sql appendString:[VVDBQueryBuilder selectConditionOptionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)selectRowidStatement:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.selectRowidTemplateStatement];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition]];
    return [NSString stringWithString:sql];
}


- (NSString *)deleteFromStatementWithCondition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.deleteFromTemplateStatement];
    [sql appendString:[VVDBQueryBuilder deleteConditionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)referencedCountStatementWithCondition:(VVDBConditionModel *)condition {
    NSString *conditionStatement = [VVDBQueryBuilder selectConditionStatement:condition runtime:self];
    NSString *sql = self.referencedCountTemplateStatement;
    sql = [NSString stringWithFormat:sql, conditionStatement];
    return sql;
}

- (NSString *)countStatementWithCondition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.countTemplateStatement];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return [NSString stringWithString:sql];
}

- (NSString *)minStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVDBQueryBuilder minStatement:self columnName:columnName]];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return sql;
}

- (NSString *)maxStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVDBQueryBuilder maxStatement:self columnName:columnName]];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return sql;
}

- (NSString *)avgStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVDBQueryBuilder avgStatement:self columnName:columnName]];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return sql;
}

- (NSString *)totalStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVDBQueryBuilder totalStatement:self columnName:columnName]];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return sql;
}

- (NSString *)sumStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVDBQueryBuilder sumStatement:self columnName:columnName]];
    [sql appendString:[VVDBQueryBuilder selectConditionStatement:condition runtime:self]];
    return sql;
}

#pragma marks unique condition

- (VVDBConditionModel *)rowidCondition:(NSObject *)object {
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = [VVDBQueryBuilder rowidConditionStatement];
    condition.sqlite.parameters = [self rowidAttributeParameter:object];
    return condition;
}

- (VVDBConditionModel *)uniqueCondition:(NSObject *)object {
    VVDBConditionModel *condition = [VVDBConditionModel condition];
    condition.sqlite.where = [VVDBQueryBuilder uniqueConditionStatement:self];
    condition.sqlite.parameters = [self identificationAttributesParameters:object];
    return condition;
}

#pragma marks parameter methods

- (NSMutableArray *)insertAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVStoreRuntimeProperty *attribute in self.insertAttributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)insertOrIgnoreAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVStoreRuntimeProperty *attribute in self.insertAttributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)insertOrReplaceAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVStoreRuntimeProperty *attribute in self.attributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)updateAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    if (self.hasNotUpdateIfValueIsNullAttribute) {
        for (VVStoreRuntimeProperty *attribute in self.updateAttributes) {
            NSObject *value = [object valueForKey:attribute.name];
            if (value) {
                NSArray *values = [attribute storeValuesWithObject:object];
                [parameters addObjectsFromArray:values];
            }
        }
    } else {
        for (VVStoreRuntimeProperty *attribute in self.updateAttributes) {
            NSArray *values = [attribute storeValuesWithObject:object];
            [parameters addObjectsFromArray:values];
        }
    }
    return parameters;
}

- (NSMutableArray *)identificationAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVStoreRuntimeProperty *attribute in self.identificationAttributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)rowidAttributeParameter:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    [parameters addObjectsFromArray:[self.attributes.firstObject storeValuesWithObject:object]];
    return parameters;
}


#pragma mark value mapper

- (id)object {
    return [self.osclazz objectWithClazz:self.clazz];
}

- (NSEnumerator *)objectEnumeratorWithObject:(id)object {
    return [self.osclazz objectEnumeratorWithObject:object];
}

- (NSArray *)keysWithObject:(id)object {
    return [self.osclazz keysWithObject:object];
}

- (id)objectWithObjects:(NSArray *)objects keys:(NSArray *)keys initializingOptions:(NSString *)initializingOptions {
    return [self.osclazz objectWithObjects:objects keys:keys initializingOptions:initializingOptions];
}

#


+ (NSString *)VVTableName {
    return @"__ObjectStoreRuntime__";
}

@end
