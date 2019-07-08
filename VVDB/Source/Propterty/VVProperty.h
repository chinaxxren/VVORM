//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVPropertyEncoding;
@class VVPropertyType;


@interface VVProperty : NSObject

- (instancetype)initWithName:(NSString *)name attributes:(NSString *)attributes;

@property(nonatomic, readonly) Class clazz;
@property(nonatomic, readonly) NSString *structureName;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *attributes;
@property(nonatomic, readonly) VVPropertyType *propertyType;
@property(nonatomic, readonly) VVPropertyEncoding *propertyEncoding;

@end
