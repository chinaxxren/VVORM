//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVProperty;


@interface VVClassProperty : NSObject

@property(nonatomic, readonly) Class clazz;
@property(nonatomic, readonly) NSArray<VVProperty *> *propertyList;

+ (VVClassProperty *)runtimeWithClass:(Class)clazz;

+ (VVClassProperty *)runtimeSuperClassWithClass:(Class)clazz;

+ (VVClassProperty *)runtimeWithClass:(Class)clazz superClazz:(Class)superClazz;

+ (VVClassProperty *)runtimeSuperClassWithClass:(Class)clazz superClazz:(Class)superClazz;

@end