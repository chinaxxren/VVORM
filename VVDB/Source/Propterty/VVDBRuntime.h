//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVModelInterface.h"

@protocol VVIgnoreAttribute;

@class VVDBClazz;
@class VVNameBuilder;
@class VVDBRuntimeProperty;
@class VVDBConditionModel;

@interface VVDBRuntime : NSObject <VVModelInterface>

//
- (instancetype)initWithClazz:(Class)clazz osclazz:(VVDBClazz *)osclazz nameBuilder:(VVNameBuilder *)nameBuilder;

// class information
@property(nonatomic, assign) Class clazz;
@property(nonatomic, strong) NSString <VVIdenticalAttribute> *clazzName;
@property(nonatomic, assign) BOOL isArrayClazz;
@property(nonatomic, assign) BOOL isSimpleValueClazz;
@property(nonatomic, assign) BOOL isObjectClazz;
@property(nonatomic, assign) BOOL isRelationshipClazz;

// attribute inforamtion
@property(nonatomic, strong) VVDBRuntimeProperty <VVIgnoreAttribute> *rowidAttribute;
@property(nonatomic, strong) NSArray *attributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *identificationAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *insertAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *updateAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *relationshipAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *simpleValueAttributes;

// class options
@property(nonatomic, assign) BOOL fullTextSearch3;
@property(nonatomic, assign) BOOL fullTextSearch4;
@property(nonatomic, assign) BOOL modelDidLoad;
@property(nonatomic, assign) BOOL modelDidSave;
@property(nonatomic, assign) BOOL modelDidDelete;

// for response
@property(nonatomic, assign) BOOL hasIdentificationAttributes;
@property(nonatomic, assign) BOOL hasRelationshipAttributes;
@property(nonatomic, assign) BOOL insertPerformance;
@property(nonatomic, assign) BOOL updatePerformance;
@property(nonatomic, assign) BOOL notification;
@property(nonatomic, assign) BOOL cascadeNotification;

//
@property(nonatomic, strong) VVDBClazz <VVSerializableAttribute> *osclazz;

// for response
@property(atomic, strong) NSString *tableName;
@property(nonatomic, strong) NSString *selectTemplateStatement;
@property(nonatomic, strong) NSString *updateTemplateStatement;
@property(nonatomic, strong) NSString *selectRowidTemplateStatement;
@property(nonatomic, strong) NSString *insertIntoTemplateStatement;
@property(nonatomic, strong) NSString *insertOrIgnoreIntoTemplateStatement;
@property(nonatomic, strong) NSString *insertOrReplaceIntoTemplateStatement;
@property(nonatomic, strong) NSString *deleteFromTemplateStatement;
@property(nonatomic, strong) NSString *createTableTemplateStatement;
@property(nonatomic, strong) NSString *dropTableTemplateStatement;
@property(nonatomic, strong) NSString *createUniqueIndexTemplateStatement;
@property(nonatomic, strong) NSString *dropIndexTemplateStatement;
@property(nonatomic, strong) NSString *countTemplateStatement;
@property(nonatomic, strong) NSString *referencedCountTemplateStatement;
@property(nonatomic, strong) NSString *uniqueIndexNameTemplateStatement;
@property(nonatomic, assign) BOOL hasNotUpdateIfValueIsNullAttribute;

// statement methods
- (NSString *)createTableStatement;

- (NSString *)dropTableStatement;

- (NSString *)createUniqueIndexStatement;

- (NSString *)dropUniqueIndexStatement;

- (NSString *)insertIntoStatement;

- (NSString *)insertOrIgnoreIntoStatement;

- (NSString *)insertOrReplaceIntoStatement;

- (NSString *)updateStatementWithObject:(NSObject *)object condition:(VVDBConditionModel *)condition;

- (NSString *)selectRowidStatement:(VVDBConditionModel *)condition;

- (NSString *)selectStatementWithCondition:(VVDBConditionModel *)condition;

- (NSString *)deleteFromStatementWithCondition:(VVDBConditionModel *)condition;

- (NSString *)referencedCountStatementWithCondition:(VVDBConditionModel *)condition;

- (NSString *)countStatementWithCondition:(VVDBConditionModel *)condition;

- (NSString *)uniqueIndexName;

- (NSString *)minStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition;

- (NSString *)maxStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition;

- (NSString *)avgStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition;

- (NSString *)totalStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition;

- (NSString *)sumStatementWithColumnName:(NSString *)columnName condition:(VVDBConditionModel *)condition;

// condition methods
- (VVDBConditionModel *)rowidCondition:(NSObject *)object;

- (VVDBConditionModel *)uniqueCondition:(NSObject *)object;

// parameter methods
- (NSMutableArray *)insertOrIgnoreAttributesParameters:(NSObject *)object;

- (NSMutableArray *)insertOrReplaceAttributesParameters:(NSObject *)object;

- (NSMutableArray *)insertAttributesParameters:(NSObject *)object;

- (NSMutableArray *)updateAttributesParameters:(NSObject *)object;

// for value in array
- (NSEnumerator *)objectEnumeratorWithObject:(id)object;

- (NSArray *)keysWithObject:(id)object;

- (id)objectWithObjects:(NSArray *)objects keys:(NSArray *)keys initializingOptions:(NSString *)initializingOptions;

- (id)object;

@end
