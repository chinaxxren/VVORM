//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazz.h"

#import "VVORMProperty.h"
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

- (NSArray *)sqliteColumnsWithAttribute:(VVORMProperty *)attribute {
    VVSQLiteColumnModel *sqliteColumn = [[VVSQLiteColumnModel alloc] init];
    sqliteColumn.columnName = attribute.columnName;
    sqliteColumn.dataTypeName = [self sqliteDataTypeName];
    return @[sqliteColumn];
}


#pragma mark constractor

+ (NSMutableArray *)vvclazzsArray {
    static NSMutableArray *_vvclazzs = nil;
    @synchronized (self) {
        if (!_vvclazzs) {
            _vvclazzs = [NSMutableArray array];

            [self addVVClazz:[VVClazzNSMutableString class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSDate class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSURL class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSString class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSDecimalNumber class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSNumber class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSData class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSValue class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSNull class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzShort class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzBool class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzInt class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzChar class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzLong class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzLongLong class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzUnsignedInt class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzUnsignedShort class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzUnsignedChar class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzUnsignedLong class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzUnsignedLongLong class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzFloat class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzDouble class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzSerialize class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSArray class] vvclazzsArray:_vvclazzs];
            [self addVVClazz:[VVClazzNSMutableArray class] vvclazzsArray:_vvclazzs];
        }
    }

    return _vvclazzs;
}

+ (NSMutableDictionary *)vvclazzDict {
    static NSMutableDictionary *_clazzDict = nil;
    @synchronized (self) {
        if (!_clazzDict) {
            _clazzDict = [NSMutableDictionary dictionary];
        }
    }

    return _clazzDict;
}

+ (void)addClazz:(Class)clazz {
    if (![clazz isSubclassOfClass:[VVClazz class]]) {
        return;
    }
    @synchronized (self) {
        NSMutableArray *vvclazzsArray = [self vvclazzsArray];
        [self addVVClazz:clazz vvclazzsArray:vvclazzsArray];
    }
}

+ (void)addVVClazz:(Class)clazz vvclazzsArray:(NSMutableArray *)vvclazzsArray {
    VVClazz *vvclazz = [[clazz alloc] init];
    [vvclazzsArray addObject:vvclazz];
}

+ (VVClazz *)vvclazzWithClazz:(Class)clazz {
    NSMutableDictionary *clazzDict = [self vvclazzDict];
    VVClazz *typeClazz = clazzDict[NSStringFromClass(clazz)];
    if (typeClazz) {
        return typeClazz;
    }
    NSMutableArray *vvclazzsArray = [self vvclazzsArray];
    if (!clazz) {
        return [self clazzIdInstance];
    }
    for (VVClazz *vvclazz in vvclazzsArray) {
        if (vvclazz.superClazz != [NSObject class]) {
            if ([vvclazz isSubClazz:clazz]) {
                clazzDict[NSStringFromClass(clazz)] = vvclazz;
                return vvclazz;
            }
        }
    }
    typeClazz = [self clazzNSObjectInstance];
    clazzDict[NSStringFromClass(clazz)] = typeClazz;
    return typeClazz;
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
    NSMutableDictionary *vvclazzs = [self vvclazzDict];
    VVClazz *vvclazz = vvclazzs[key];
    if (!vvclazz) {
        NSMutableArray *vvclazzsArray = [self vvclazzsArray];
        for (VVClazz *newvvclazz in vvclazzsArray) {
            if ([newvvclazz.attributeType isEqualToString:key]) {
                vvclazz = newvvclazz;
                break;
            }
        }
        if (vvclazz) {
            vvclazzs[key] = vvclazz;
        }
    }
    return vvclazz;
}

+ (VVClazz *)vvclazzWithStructureName:(NSString *)StructureName {
    NSString *key = StructureName;
    NSMutableDictionary *vvclazzs = [self vvclazzDict];
    VVClazz *vvclazz = vvclazzs[key];
    if (!vvclazz) {
        NSMutableArray *vvclazzsArray = [self vvclazzsArray];
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
