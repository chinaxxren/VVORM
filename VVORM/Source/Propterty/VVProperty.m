//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVProperty.h"

#import "VVPropertyEncoding.h"
#import "VVPropertyType.h"

@implementation VVProperty

- (instancetype)initWithName:(NSString *)name attributes:(NSString *)attributes {
    self = [super init];
    if (self) {
        _name = name;
        _attributes = attributes;
        _propertyType = [[VVPropertyType alloc] initWithAttributes:attributes];
        _propertyEncoding = [[VVPropertyEncoding alloc] initWithAttributes:attributes];
        _clazz = [self classWithAttributes:attributes];
        _structureName = [self structureNameWithAttributes:attributes];
    }
    return self;
}

- (NSString *)structureNameWithAttributes:(NSString *)attributes {
    NSString *structureName = nil;
    if (_propertyEncoding.isStructure) {
        NSArray *attributeList = [attributes componentsSeparatedByString:@","];
        NSString *firstAttribute = [attributeList firstObject];
        if (firstAttribute.length > 3) {
            NSString *name = [firstAttribute substringWithRange:NSMakeRange(2, firstAttribute.length - 3)];
            NSArray *names = [name componentsSeparatedByString:@"="];
            structureName = names.firstObject;
        }
    }
    return structureName;
}

- (Class)classWithAttributes:(NSString *)attributes {
    Class clazz = Nil;
    if (_propertyEncoding.isObject) {
        NSArray *attributeList = [attributes componentsSeparatedByString:@","];
        NSString *firstAttribute = [attributeList firstObject];
        if (firstAttribute.length > 3) {
            NSString *className = [firstAttribute substringWithRange:NSMakeRange(3, firstAttribute.length - 4)];
            NSArray *names = [className componentsSeparatedByString:@"<"];
            clazz = NSClassFromString(names.firstObject);
        }
    }
    return clazz;
}

@end