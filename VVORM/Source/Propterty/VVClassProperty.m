//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "VVClassProperty.h"

#import <objc/runtime.h>

#import "VVProperty.h"


@implementation VVClassProperty

+ (VVClassProperty *)runtimeWithClass:(Class)clazz {
    return [self runtimeWithClass:clazz superClazz:[NSObject class] enumratePropertyOfSuperClass:NO];
}

+ (VVClassProperty *)runtimeSuperClassWithClass:(Class)clazz {
    return [self runtimeWithClass:clazz superClazz:[NSObject class] enumratePropertyOfSuperClass:YES];
}

+ (VVClassProperty *)runtimeWithClass:(Class)clazz superClazz:(Class)superClazz {
    return [self runtimeWithClass:clazz superClazz:superClazz enumratePropertyOfSuperClass:NO];
}

+ (VVClassProperty *)runtimeSuperClassWithClass:(Class)clazz superClazz:(Class)superClazz {
    return [self runtimeWithClass:clazz superClazz:superClazz enumratePropertyOfSuperClass:YES];
}

+ (VVClassProperty *)runtimeWithClass:(Class)clazz superClazz:(Class)superClazz enumratePropertyOfSuperClass:(BOOL)enumratePropertyOfSuperClass {
    return [[VVClassProperty alloc] initWithClass:clazz superClazz:superClazz enumratePropertyOfSuperClass:enumratePropertyOfSuperClass];
}

- (id)initWithClass:(Class)clazz superClazz:(Class)superClazz enumratePropertyOfSuperClass:(BOOL)enumratePropertyOfSuperClass {
    self = [super init];
    if (self) {
        _clazz = clazz;
        _propertyList = [self propertyListWithClass:clazz propertyList:nil superClazz:superClazz enumratePropertyOfSuperClass:enumratePropertyOfSuperClass];
    }

    return self;
}

- (NSArray *)propertyListWithClass:(Class)clazz propertyList:(NSMutableArray *)propertyList superClazz:(Class)superClazz enumratePropertyOfSuperClass:(BOOL)enumratePropertyOfSuperClass {
    if (!clazz) {
        return [NSArray arrayWithArray:propertyList];
    }

    NSString *clazzName = NSStringFromClass(clazz);
    NSString *superClazzName = NSStringFromClass(superClazz);
    if ([clazzName isEqualToString:superClazzName]) {
        return [NSArray arrayWithArray:propertyList];
    }

    NSMutableArray<VVProperty *> *proptertyList = [NSMutableArray<VVProperty *> array];
    NSString *className = NSStringFromClass(clazz);
    Class objcClass = objc_getClass([className UTF8String]);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(objcClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        VVProperty *runtimeProperty = [[VVProperty alloc] initWithName:[name copy] attributes:[attributes copy]];
        [proptertyList addObject:runtimeProperty];
    }
    free(properties);

    if (proptertyList.count > 0) {
        if (!propertyList) {
            propertyList = [NSMutableArray array];
        }
        [propertyList addObjectsFromArray:proptertyList];
    }

    if (enumratePropertyOfSuperClass) {
        clazz = [clazz superclass];
        return [self propertyListWithClass:clazz propertyList:propertyList superClazz:superClazz enumratePropertyOfSuperClass:enumratePropertyOfSuperClass];
    } else {
        return [NSArray arrayWithArray:propertyList];
    }
}


@end