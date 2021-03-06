//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVORMClass.h"

#import "VVClazz.h"
#import "VVNameBuilder.h"
#import "VVPropertyInfo.h"
#import "VVConditionModel.h"
#import "VVSQLiteConditionModel.h"
#import "VVQueryBuilder.h"
#import "VVReferenceModel.h"
#import "VVClassProperty.h"
#import "VVProperty.h"
#import "VVPropertyType.h"

@implementation VVORMClass

- (instancetype)initWithClazz:(Class)clazz osclazz:(VVClazz *)osclazz nameBuilder:(VVNameBuilder *)nameBuilder {
    if (self = [super init]) {
        [self setupWithClazz:clazz vvclazz:osclazz nameBuilder:nameBuilder];
    }
    return self;
}

- (void)setupWithClazz:(Class)clazz vvclazz:(VVClazz *)vvclazz nameBuilder:(VVNameBuilder *)nameBuilder {
    // clazz
    self.clazz = clazz;
    self.clazzName = NSStringFromClass(clazz);

    // mapper
    self.vvclazz = vvclazz;
    self.isArrayClazz = self.vvclazz.isArrayClazz;
    self.isObjectClazz = self.vvclazz.isObjectClazz;
    self.isSimpleValueClazz = self.vvclazz.isSimpleValueClazz;

    if (!self.isObjectClazz) {
        return;
    }

    // table name and column name for query builder
    self.tableName = [nameBuilder tableName:self.clazz];

    // class options
    self.fullTextSearch3 = [self.clazz conformsToProtocol:@protocol(VVFullTextSearch3)];
    self.fullTextSearch4 = [self.clazz conformsToProtocol:@protocol(VVFullTextSearch4)];

    // attributes
    VVClassProperty *bzruntime = nil;
    if ([self.clazz conformsToProtocol:@protocol(VVIgnoreSuperClass)]) {
        bzruntime = [VVClassProperty runtimeWithClass:self.clazz superClazz:self.vvclazz.superClazz];
    } else {
        bzruntime = [VVClassProperty runtimeSuperClassWithClass:self.clazz superClazz:self.vvclazz.superClazz];
    }
    NSMutableArray *propertyList = [NSMutableArray array];
    NSArray *requiredPropertyListOnEachClazz = [self.vvclazz requiredPropertyList];
    if (requiredPropertyListOnEachClazz) {
        [propertyList addObjectsFromArray:requiredPropertyListOnEachClazz];
    }
    for (VVProperty *prop in bzruntime.propertyList) {
        NSString *from = [prop.name uppercaseString];
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
                [propertyList addObject:prop];
            }
        }
    }
    NSMutableArray *insertAttributes = [NSMutableArray array];
    NSMutableArray *identicalAttributes = [NSMutableArray array];
    NSMutableArray *updateAttributes = [NSMutableArray array];
    NSMutableArray *relationshipAttributes = [NSMutableArray array];
    NSMutableArray *simpleValueAttributes = [NSMutableArray array];
    for (VVProperty *vvproperty in propertyList) {
        VVPropertyInfo *ormAttribute = [VVPropertyInfo propertyWithBZProperty:vvproperty ormClass:self nameBuilder:nameBuilder];
        if (ormAttribute.isValid) {
            if (!ormAttribute.ignoreAttribute && !vvproperty.propertyType.isReadonly) {
                [insertAttributes addObject:ormAttribute];
                if (ormAttribute.identicalAttribute) {
                    [identicalAttributes addObject:ormAttribute];
                }
                if (!ormAttribute.onceUpdateAttribute) {
                    [updateAttributes addObject:ormAttribute];
                }
                if (ormAttribute.notUpdateIfValueIsNullAttribute) {
                    self.hasNotUpdateIfValueIsNullAttribute = YES;
                }
                if (ormAttribute.isRelationshipClazz) {
                    [relationshipAttributes addObject:ormAttribute];
                }
                if (ormAttribute.isSimpleValueClazz) {
                    [simpleValueAttributes addObject:ormAttribute];
                }
            }
        }
    }

    VVClassProperty *referenceRuntime = [VVClassProperty runtimeWithClass:[VVReferenceModel class]];
    VVPropertyInfo *rowidAttribute = [VVPropertyInfo propertyWithBZProperty:referenceRuntime.propertyList.firstObject ormClass:self nameBuilder:nameBuilder];
    NSMutableArray *attributes = [NSMutableArray array];
    [attributes addObject:rowidAttribute];
    [attributes addObjectsFromArray:insertAttributes];
    [simpleValueAttributes addObject:rowidAttribute];

    self.rowidAttribute = rowidAttribute;
    self.attributes = [NSArray arrayWithArray:attributes];
    self.insertAttributes = [NSArray arrayWithArray:insertAttributes];
    self.updateAttributes = [NSArray arrayWithArray:updateAttributes];
    self.identificationAttributes = [NSArray arrayWithArray:identicalAttributes];
    self.simpleValueAttributes = [NSArray arrayWithArray:simpleValueAttributes];

    // response
    if (self.identificationAttributes.count > 0) {
        self.hasIdentificationAttributes = YES;
    } else {
        self.hasIdentificationAttributes = NO;
    }
    self.insertPerformance = [self.clazz conformsToProtocol:@protocol(VVInsertPerformance)];
    self.updatePerformance = [self.clazz conformsToProtocol:@protocol(VVUpdatePerformance)];

    if (self.insertPerformance == NO && self.updatePerformance == NO) {
        self.insertPerformance = YES;
    }

    // query
    self.selectTemplateStatement = [VVQueryBuilder selectStatement:self];
    self.updateTemplateStatement = [VVQueryBuilder updateStatement:self];
    self.selectRowidTemplateStatement = [VVQueryBuilder selectRowidStatement:self];
    self.insertIntoTemplateStatement = [VVQueryBuilder insertIntoStatement:self];
    self.insertOrIgnoreIntoTemplateStatement = [VVQueryBuilder insertOrIgnoreIntoStatement:self];
    self.insertOrReplaceIntoTemplateStatement = [VVQueryBuilder insertOrReplaceIntoStatement:self];
    self.deleteFromTemplateStatement = [VVQueryBuilder deleteFromStatement:self];
    self.createTableTemplateStatement = [VVQueryBuilder createTableStatement:self];
    self.dropTableTemplateStatement = [VVQueryBuilder dropTableStatement:self];
    self.createUniqueIndexTemplateStatement = [VVQueryBuilder createUniqueIndexStatement:self];
    self.dropIndexTemplateStatement = [VVQueryBuilder dropIndexStatement:self];
    self.countTemplateStatement = [VVQueryBuilder countStatement:self];
    self.uniqueIndexNameTemplateStatement = [VVQueryBuilder uniqueIndexName:self];
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

- (NSString *)updateStatementWithObject:(NSObject *)object condition:(VVConditionModel *)condition {
    if (self.hasNotUpdateIfValueIsNullAttribute) {
        NSMutableArray *attributes = [NSMutableArray array];
        for (VVPropertyInfo *attribute in self.updateAttributes) {
            NSValue *value = [object valueForKey:attribute.name];
            if (value) {
                [attributes addObject:attribute];
            }
        }
        NSMutableString *sql = [NSMutableString string];
        [sql appendString:[VVQueryBuilder updateStatement:self attributes:attributes]];
        [sql appendString:[VVQueryBuilder updateConditionStatement:condition]];
        return [NSString stringWithString:sql];
    } else {
        NSMutableString *sql = [NSMutableString string];
        [sql appendString:self.updateTemplateStatement];
        [sql appendString:[VVQueryBuilder updateConditionStatement:condition]];
        return [NSString stringWithString:sql];
    }
}

- (NSString *)selectStatementWithCondition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.selectTemplateStatement];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    [sql appendString:[VVQueryBuilder selectConditionOptionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)selectRowidStatement:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.selectRowidTemplateStatement];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)deleteFromStatementWithCondition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.deleteFromTemplateStatement];
    [sql appendString:[VVQueryBuilder deleteConditionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)countStatementWithCondition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:self.countTemplateStatement];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return [NSString stringWithString:sql];
}

- (NSString *)minStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVQueryBuilder minStatement:self columnName:columnName]];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return sql;
}

- (NSString *)maxStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVQueryBuilder maxStatement:self columnName:columnName]];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return sql;
}

- (NSString *)avgStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVQueryBuilder avgStatement:self columnName:columnName]];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return sql;
}

- (NSString *)totalStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVQueryBuilder totalStatement:self columnName:columnName]];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return sql;
}

- (NSString *)sumStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition {
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[VVQueryBuilder sumStatement:self columnName:columnName]];
    [sql appendString:[VVQueryBuilder selectConditionStatement:condition]];
    return sql;
}

#pragma marks unique condition

- (VVConditionModel *)rowidCondition:(NSObject *)object {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = [VVQueryBuilder rowidConditionStatement];
    condition.sqlite.parameters = [self rowidAttributeParameter:object];
    return condition;
}

- (VVConditionModel *)uniqueCondition:(NSObject *)object {
    VVConditionModel *condition = [VVConditionModel condition];
    condition.sqlite.where = [VVQueryBuilder uniqueConditionStatement:self];
    condition.sqlite.parameters = [self identificationAttributesParameters:object];
    return condition;
}

#pragma marks parameter methods

- (NSMutableArray *)insertAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVPropertyInfo *attribute in self.insertAttributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)insertOrIgnoreAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVPropertyInfo *attribute in self.insertAttributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)insertOrReplaceAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVPropertyInfo *attribute in self.attributes) {
        [parameters addObjectsFromArray:[attribute storeValuesWithObject:object]];
    }
    return parameters;
}

- (NSMutableArray *)updateAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    if (self.hasNotUpdateIfValueIsNullAttribute) {
        for (VVPropertyInfo *attribute in self.updateAttributes) {
            NSObject *value = [object valueForKey:attribute.name];
            if (value) {
                NSArray *values = [attribute storeValuesWithObject:object];
                [parameters addObjectsFromArray:values];
            }
        }
    } else {
        for (VVPropertyInfo *attribute in self.updateAttributes) {
            NSArray *values = [attribute storeValuesWithObject:object];
            [parameters addObjectsFromArray:values];
        }
    }
    return parameters;
}

- (NSMutableArray *)identificationAttributesParameters:(NSObject *)object {
    NSMutableArray *parameters = [NSMutableArray array];
    for (VVPropertyInfo *attribute in self.identificationAttributes) {
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
    return [self.vvclazz objectWithClazz:self.clazz];
}

#

+ (NSString *)VVTableName {
    return @"__VVORMClass__";
}

@end
