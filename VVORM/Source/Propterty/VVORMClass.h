//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVModelInterface.h"

@protocol VVIgnoreAttribute;

@class VVClazz;
@class VVNameBuilder;
@class VVORMProperty;
@class VVConditionModel;

@interface VVORMClass : NSObject <VVModelInterface>

//
- (instancetype)initWithClazz:(Class)clazz osclazz:(VVClazz *)osclazz nameBuilder:(VVNameBuilder *)nameBuilder;

// class information
@property(nonatomic, assign) Class clazz;
@property(nonatomic, strong) NSString <VVIdenticalAttribute> *clazzName;
@property(nonatomic, assign) BOOL isArrayClazz;
@property(nonatomic, assign) BOOL isSimpleValueClazz;
@property(nonatomic, assign) BOOL isObjectClazz;

// attribute inforamtion
@property(nonatomic, strong) VVORMProperty <VVIgnoreAttribute> *rowidAttribute;
@property(nonatomic, strong) NSArray *attributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *identificationAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *insertAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *updateAttributes;
@property(nonatomic, strong) NSArray <VVIgnoreAttribute> *simpleValueAttributes;

// class options
@property(nonatomic, assign) BOOL fullTextSearch3;
@property(nonatomic, assign) BOOL fullTextSearch4;

// for response
@property(nonatomic, assign) BOOL hasIdentificationAttributes;
@property(nonatomic, assign) BOOL insertPerformance;
@property(nonatomic, assign) BOOL updatePerformance;

//
@property(nonatomic, strong) VVClazz <VVSerializableAttribute> *vvclazz;

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

- (NSString *)updateStatementWithObject:(NSObject *)object condition:(VVConditionModel *)condition;

- (NSString *)selectRowidStatement:(VVConditionModel *)condition;

- (NSString *)selectStatementWithCondition:(VVConditionModel *)condition;

- (NSString *)deleteFromStatementWithCondition:(VVConditionModel *)condition;

- (NSString *)countStatementWithCondition:(VVConditionModel *)condition;

- (NSString *)uniqueIndexName;

- (NSString *)minStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition;

- (NSString *)maxStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition;

- (NSString *)avgStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition;

- (NSString *)totalStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition;

- (NSString *)sumStatementWithColumnName:(NSString *)columnName condition:(VVConditionModel *)condition;

// condition methods
- (VVConditionModel *)rowidCondition:(NSObject *)object;

- (VVConditionModel *)uniqueCondition:(NSObject *)object;

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
