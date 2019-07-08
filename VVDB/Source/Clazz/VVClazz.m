//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazz.h"

#import "VVRuntimeProperty.h"
#import "VVSQLiteColumnModel.h"
#import "VVClazzID.h"
#import "VVClazzNSMutableString.h"
#import "VVClazzNSObject.h"
#import "VVClazzNSValue.h"
#import "VVClazzNSDate.h"
#import "VVClazzNSURL.h"
#import "VVClazzNSString.h"
#import "VVClazzNSDecimalNumber.h"
#import "VVClazzNSNumber.h"
#import "VVClazzNSData.h"
#import "VVClazzNSNull.h"
#import "VVClazzBool.h"
#import "VVClazzInt.h"
#import "VVClazzChar.h"
#import "VVClazzLong.h"
#import "VVClazzLongLong.h"
#import "VVClazzUnsignedInt.h"
#import "VVClazzUnsignedShort.h"
#import "VVClazzUnsignedChar.h"
#import "VVClazzUnsignedLong.h"
#import "VVClazzUnsignedLongLong.h"
#import "VVClazzFloat.h"
#import "VVClazzShort.h"
#import "VVClazzDouble.h"
#import "VVClazzSerialize.h"
#import "VVClazzNSArray.h"
#import "VVClazzNSMutableArray.h"

@implementation VVClazz


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

- (NSArray *)sqliteColumnsWithAttribute:(VVRuntimeProperty *)attribute {
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
            [self addOSClazz:[VVClazzNSMutableString class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSDate class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSURL class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSString class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSDecimalNumber class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSNumber class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSData class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSValue class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSNull class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzShort class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzBool class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzInt class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzChar class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzLongLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzUnsignedInt class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzUnsignedShort class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzUnsignedChar class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzUnsignedLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzUnsignedLongLong class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzFloat class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzDouble class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzSerialize class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSArray class] vvclazzsArray:clazzsArray];
            [self addOSClazz:[VVClazzNSMutableArray class] vvclazzsArray:clazzsArray];
        }
    }

    return _clazzs;
}

+ (void)addClazz:(Class)clazz {
    if (![clazz isSubclassOfClass:[VVClazz class]]) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        [self addOSClazz:clazz vvclazzsArray:osclazzsArray];
    }
}

+ (void)addOSClazz:(Class)clazz vvclazzsArray:(NSMutableArray *)osclazzsArray {
    VVClazz *osclazz = [[clazz alloc] init];
    [osclazzsArray addObject:osclazz];
}


+ (VVClazz *)vvclazzWithClazz:(Class)clazz {
    NSMutableDictionary *osclazzs = [self vvclazzs];
    VVClazz *osclazz = osclazzs[NSStringFromClass(clazz)];
    if (osclazz) {
        return osclazz;
    }
    NSMutableArray *osclazzsArray = [self osclazzsArray];
    if (!clazz) {
        return [self clazzIdInstance];
    }
    for (VVClazz *osclazz in osclazzsArray) {
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

+ (VVClazzID *)clazzIdInstance {
    static VVClazzID *_clazzIdInstance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        if (!_clazzIdInstance) {
            _clazzIdInstance = [[VVClazzID alloc] init];
        }
    });

    return _clazzIdInstance;
}

+ (VVClazzNSObject *)clazzNSObjectInstance {
    static VVClazzNSObject *_clazzNSObjectInstance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        if (!_clazzNSObjectInstance) {
            _clazzNSObjectInstance = [[VVClazzNSObject alloc] init];
        }
    });

    return _clazzNSObjectInstance;
}

+ (VVClazz *)vvclazzWithPrimitiveEncodingCode:(NSString *)primitiveEncodingCode {
    NSString *key = primitiveEncodingCode;
    NSMutableDictionary *osclazzs = [self vvclazzs];
    VVClazz *osclazz = osclazzs[key];
    if (!osclazz) {
        NSMutableArray *osclazzsArray = [self osclazzsArray];
        for (VVClazz *newosclazz in osclazzsArray) {
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

+ (VVClazz *)vvclazzWithStructureName:(NSString *)StructureName {
    NSString *key = StructureName;
    NSMutableDictionary *vvclazzs = [self vvclazzs];
    VVClazz *vvclazz = vvclazzs[key];
    if (!vvclazz) {
        NSMutableArray *vvclazzsArray = [self osclazzsArray];
        for (VVClazz *newvvclazz in vvclazzsArray) {
            if ([newvvclazz.attributeType isEqualToString:key]) {
                vvclazz = newvvclazz;
                break;
            }
        }

        if (!vvclazz) {
            vvclazz = [[VVClazzNSValue alloc] init];
        }

        if (vvclazz) {
            vvclazzs[key] = vvclazz;
        }
    }

    return vvclazz;
}

@end
