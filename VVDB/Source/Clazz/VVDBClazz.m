//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVStoreClazz.h"
#import "VVStoreRuntimeProperty.h"
#import "VVStoreSQLiteColumnModel.h"


@implementation VVStoreClazz


#pragma mark override methods, properties

- (Class)superClazz {
    return nil;
}

- (BOOL)isSubClazz:(Class)clazz {
    return [clazz isSubclassOfClass:self.superClazz];
}

- (BOOL)isSimpleValueClazz {
    return NO;
}

- (BOOL)isArrayClazz {
    return NO;
}

- (BOOL)isObjectClazz {
    return NO;
}

- (BOOL)isRelationshipClazz {
    return NO;
}

- (BOOL)isPrimaryClazz {
    return NO;
}

- (NSArray *)requiredPropertyList {
    return nil;
}

- (NSArray *)sqliteColumnsWithAttribute:(VVStoreRuntimeProperty *)attribute {
    VVStoreSQLiteColumnModel *sqliteColumn = [[VVStoreSQLiteColumnModel alloc] init];
    sqliteColumn.columnName = attribute.columnName;
    sqliteColumn.dataTypeName = [self sqliteDataTypeName];
    return @[sqliteColumn];
}


#pragma mark constractor

+ (NSMutableArray *)osclazzsArray {
    static NSMutableArray *_osclazzs = nil;
    if (!_osclazzs) {
        @synchronized (self) {
            _osclazzs = [NSMutableArray array];
        }
    }
    return _osclazzs;
}

+ (NSMutableDictionary *)osclazzs {
    static NSMutableDictionary *_osclazzs = nil;
    if (!_osclazzs) {
        @synchronized (self) {
            NSMutableArray *osclazzsArray = [self osclazzsArray];
            _osclazzs = [NSMutableDictionary dictionary];
//            [self addOSClazz:[VVStoreClazzNSMutableString class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSMutableArray class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSMutableDictionary class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSMutableSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSMutableOrderedSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSDate class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSURL class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSString class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSDecimalNumber class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSNumber class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSData class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUIColor class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUIImage class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSImage class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSValue class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSNull class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSArray class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSDictionary class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSOrderedSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzC99Bool class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzInt class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzChar class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzLong class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzLongLong class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedInt class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedShort class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedChar class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedLong class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedLongLong class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzFloat class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzShort class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzDouble class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzUnsignedChar class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzCGRect class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzCGSize class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzCGPoint class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzNSRange class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVStoreClazzSerialize class] osclazzsArray:osclazzsArray];
        }
    }
    return _osclazzs;
}

+ (void)addClazz:(Class)clazz {
    if (![clazz isSubclassOfClass:[VVStoreClazz class]]) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        [self addOSClazz:clazz osclazzsArray:osclazzsArray];
    }
}

+ (void)addOSClazz:(Class)clazz osclazzsArray:(NSMutableArray *)osclazzsArray {
    VVStoreClazz *osclazz = [[clazz alloc] init];
    [osclazzsArray addObject:osclazz];
}


+ (VVStoreClazz *)osclazzWithClazz:(Class)clazz {
    NSMutableDictionary *osclazzs = [self osclazzs];
    VVStoreClazz *osclazz = osclazzs[NSStringFromClass(clazz)];
    if (osclazz) {
        return osclazz;
    }
    NSMutableArray *osclazzsArray = [self osclazzsArray];
    if (!clazz) {
        return [self clazzIdInstance];
    }
    for (VVStoreClazz *osclazz in osclazzsArray) {
        if (osclazz.superClazz != [NSObject class]) {
            if ([osclazz isSubClazz:clazz]) {
                osclazzs[NSStringFromClass(clazz)] = osclazz;
                return osclazz;
            }
        }
    }
    osclazz = [self clazzNSObjectInstance];
    osclazzs[NSStringFromClass(clazz)] = osclazz;
    return osclazz;
}

+ (VVStoreClazzID *)clazzIdInstance {
    static id _clazzIdInstance = nil;
    @synchronized (self) {
        if (!_clazzIdInstance) {
            _clazzIdInstance = [[VVStoreClazzID alloc] init];
        }
        return _clazzIdInstance;
    }
}

+ (VVStoreClazzNSObject *)clazzNSObjectInstance {
    static id _clazzNSObjectInstance = nil;
    @synchronized (self) {
        if (!_clazzNSObjectInstance) {
            _clazzNSObjectInstance = [[VVStoreClazzNSObject alloc] init];
        }
        return _clazzNSObjectInstance;
    }
}

+ (VVStoreClazz *)osclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode {
    NSString *key = primitiveEncodingCode;
    NSMutableDictionary *osclazzs = [self osclazzs];
    VVStoreClazz *osclazz = [osclazzs objectForKey:key];
    if (!osclazz) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        for (VVStoreClazz *newosclazz in osclazzsArray) {
            if ([newosclazz.attributeType isEqualToString:key]) {
                osclazz = newosclazz;
                break;
            }
        }
        if (osclazz) {
            [osclazzs setObject:osclazz forKey:key];
        }
    }
    return osclazz;
}

+ (VVStoreClazz *)osclazzWithStructureName:(NSString *)StructureName {
    NSString *key = StructureName;
    NSMutableDictionary *osclazzs = [self osclazzs];
    VVStoreClazz *osclazz = [osclazzs objectForKey:key];
    if (!osclazz) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        for (VVStoreClazz *newosclazz in osclazzsArray) {
            if ([newosclazz.attributeType isEqualToString:key]) {
                osclazz = newosclazz;
                break;
            }
        }
        if (!osclazz) {
            osclazz = [[VVStoreClazzNSValue alloc] init];
        }
        if (osclazz) {
            [osclazzs setObject:osclazz forKey:key];
        }
    }
    return osclazz;
}

@end