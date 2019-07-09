//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVModelInterface.h"


@interface VVORMRelationship : NSObject <VVModelInterface>

@property(nonatomic, copy) NSString <VVIdenticalAttribute> *fromClassName;
@property(nonatomic, copy) NSString *fromTableName;
@property(nonatomic, copy) NSString <VVIdenticalAttribute> *fromAttributeName;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *fromRowid;
@property(nonatomic, copy) NSString <VVIdenticalAttribute> *toClassName;
@property(nonatomic, copy) NSString *toTableName;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *toRowid;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *attributeLevel;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *attributeSequence;
@property(nonatomic, strong) NSNumber *attributeParentLevel;
@property(nonatomic, strong) NSNumber *attributeParentSequence;
@property(nonatomic, copy) NSString *attributeKey;
@property(nonatomic, strong) id attributeValue;
@property(nonatomic, strong) NSObject <VVIgnoreAttribute> *attributeFromObject;
@property(nonatomic, strong) NSObject <VVIgnoreAttribute> *attributeToObject;

+ (NSString *)VVTableName;

@end