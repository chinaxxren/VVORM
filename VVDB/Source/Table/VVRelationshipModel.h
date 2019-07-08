//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVModelInterface.h"


@interface VVRelationshipModel : NSObject <VVModelInterface>

@property(nonatomic, strong) NSString <VVIdenticalAttribute> *fromClassName;
@property(nonatomic, strong) NSString *fromTableName;
@property(nonatomic, strong) NSString <VVIdenticalAttribute> *fromAttributeName;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *fromRowid;
@property(nonatomic, strong) NSString <VVIdenticalAttribute> *toClassName;
@property(nonatomic, strong) NSString *toTableName;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *toRowid;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *attributeLevel;
@property(nonatomic, strong) NSNumber <VVIdenticalAttribute> *attributeSequence;
@property(nonatomic, strong) NSNumber *attributeParentLevel;
@property(nonatomic, strong) NSNumber *attributeParentSequence;
@property(nonatomic, strong) NSString *attributeKey;
@property(nonatomic, strong) id attributeValue;
@property(nonatomic, strong) NSObject <VVIgnoreAttribute> *attributeFromObject;
@property(nonatomic, strong) NSObject <VVIgnoreAttribute> *attributeToObject;

+ (NSString *)VVTableName;

@end