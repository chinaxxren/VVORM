//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazz.h"

#import "VVDBRuntimeProperty.h"
#import "VVSQLiteColumnModel.h"
#import "VVDBClazzNSMutableString.h"
#import "VVDBClazzID.h"
#import "VVDBClazzNSObject.h"
#import "VVDBClazzNSValue.h"
#import "VVDBClazzNSDate.h"
#import "VVDBClazzNSURL.h"
#import "VVDBClazzNSString.h"
#import "VVDBClazzNSDecimalNumber.h"
#import "VVDBClazzNSNumber.h"
#import "VVDBClazzNSData.h"
#import "VVDBClazzNSNull.h"
#import "VVDBClazzBool.h"
#import "VVDBClazzInt.h"
#import "VVDBClazzChar.h"
#import "VVDBClazzLong.h"
#import "VVDBClazzLongLong.h"
#import "VVDBClazzUnsignedInt.h"
#import "VVDBClazzUnsignedShort.h"
#import "VVDBClazzUnsignedChar.h"
#import "VVDBClazzUnsignedLong.h"
#import "VVDBClazzUnsignedLongLong.h"
#import "VVDBClazzFloat.h"
#import "VVDBClazzShort.h"
#import "VVDBClazzDouble.h"
#import "VVDBClazzSerialize.h"
#import "VVDBClazzNSArray.h"

@implementation VVDBClazz


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

- (NSArray *)sqliteColumnsWithAttribute:(VVDBRuntimeProperty *)attribute {
    VVSQLiteColumnModel *sqliteColumn = [[VVSQLiteColumnModel alloc] init];
    sqliteColumn.columnName = attribute.columnName;
    sqliteColumn.dataTypeName = [self sqliteDataTypeName];
    return @[sqliteColumn];
}


#pragma mark constractor

+ (NSMutableArray *)osclazzsArray {
    static NSMutableArray *_vvclazzs = nil;
    if (!_vvclazzs) {
        @synchronized (self) {
            _vvclazzs = [NSMutableArray array];
        }
    }
    return _vvclazzs;
}

+ (NSMutableDictionary *)vvclazzs {
    static NSMutableDictionary *_clazzs = nil;
    if (!_clazzs) {
        @synchronized (self) {
            NSMutableArray *clazzsArray = [self osclazzsArray];
            _clazzs = [NSMutableDictionary dictionary];
            [self addOSClazz:[VVDBClazzNSMutableString class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSDate class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSURL class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSString class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSDecimalNumber class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSNumber class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSData class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSValue class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSNull class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzBool class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzInt class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzChar class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzLongLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzUnsignedInt class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzUnsignedShort class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzUnsignedChar class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzUnsignedLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzUnsignedLongLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzFloat class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzShort class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzDouble class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzSerialize class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVDBClazzNSArray class] vvclazzsArray:clazzsArray];

//            [self addOSClazz:[VVDBClazzNSMutableArray class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSMutableDictionary class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSMutableSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSMutableOrderedSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzUIColor class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzUIImage class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSImage class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSDictionary class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSOrderedSet class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzCGRect class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzCGSize class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzCGPoint class] osclazzsArray:osclazzsArray];
//            [self addOSClazz:[VVDBClazzNSRange class] osclazzsArray:osclazzsArray];
        }
    }

    return _clazzs;
}

+ (void)addClazz:(Class)clazz {
    if (![clazz isSubclassOfClass:[VVDBClazz class]]) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        [self addOSClazz:clazz vvclazzsArray:osclazzsArray];
    }
}

+ (void)addOSClazz:(Class)clazz vvclazzsArray:(NSMutableArray *)osclazzsArray {
    VVDBClazz *osclazz = [[clazz alloc] init];
    [osclazzsArray addObject:osclazz];
}


+ (VVDBClazz *)vvclazzWithClazz:(Class)clazz {
    NSMutableDictionary *osclazzs = [self vvclazzs];
    VVDBClazz *osclazz = osclazzs[NSStringFromClass(clazz)];
    if (osclazz) {
        return osclazz;
    }
    NSMutableArray *osclazzsArray = [self osclazzsArray];
    if (!clazz) {
        return [self clazzIdInstance];
    }
    for (VVDBClazz *osclazz in osclazzsArray) {
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

+ (VVDBClazzID *)clazzIdInstance {
    static VVDBClazzID *_clazzIdInstance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        if (!_clazzIdInstance) {
            _clazzIdInstance = [[VVDBClazzID alloc] init];
        }
    });

    return _clazzIdInstance;
}

+ (VVDBClazzNSObject *)clazzNSObjectInstance {
    static VVDBClazzNSObject *_clazzNSObjectInstance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        if (!_clazzNSObjectInstance) {
            _clazzNSObjectInstance = [[VVDBClazzNSObject alloc] init];
        }
    });

    return _clazzNSObjectInstance;
}

+ (VVDBClazz *)vvclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode {
    NSString *key = primitiveEncodingCode;
    NSMutableDictionary *osclazzs = [self vvclazzs];
    VVDBClazz *osclazz = osclazzs[key];
    if (!osclazz) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        for (VVDBClazz *newosclazz in osclazzsArray) {
            if ([newosclazz.attributeType isEqualToString:key]) {
                osclazz = newosclazz;
                break;
            }
        }
        if (osclazz) {
            osclazzs[key] = osclazz;
        }
    }
    return osclazz;
}

+ (VVDBClazz *)vvclazzWithStructureName:(NSString *)StructureName {
    NSString *key = StructureName;
    NSMutableDictionary *vvclazzs = [self vvclazzs];
    VVDBClazz *vvclazz = vvclazzs[key];
    if (!vvclazz) {
        NSMutableArray *vvclazzsArray = [self osclazzsArray];
        for (VVDBClazz *newvvclazz in vvclazzsArray) {
            if ([newvvclazz.attributeType isEqualToString:key]) {
                vvclazz = newvvclazz;
                break;
            }
        }

        if (!vvclazz) {
            vvclazz = [[VVDBClazzNSValue alloc] init];
        }

        if (vvclazz) {
            vvclazzs[key] = vvclazz;
        }
    }

    return vvclazz;
}

@end