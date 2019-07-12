//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVReferenceMapper.h"

#import <FMDB/FMDatabaseQueue.h>

#import "VVModelInterface.h"
#import "VVConditionModel.h"
#import "VVORMClass.h"
#import "VVPropertyInfo.h"
#import "VVNameBuilder.h"
#import "VVClazz.h"
#import "NSObject+VVTabel.h"

@interface VVModelMapper (Protected)

- (NSNumber *)avg:(VVORMClass *)ormClass columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)total:(VVORMClass *)ormClass columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)sum:(VVORMClass *)ormClass columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)min:(VVORMClass *)ormClass columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)max:(VVORMClass *)ormClass columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)count:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (BOOL)insertOrUpdate:(NSObject *)object db:(FMDatabase *)db;

- (BOOL)deleteFrom:(NSObject *)object db:(FMDatabase *)db;

- (BOOL)deleteFrom:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSMutableArray *)find:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (void)updateRowid:(NSObject *)object db:(FMDatabase *)db;

- (void)updateRowidWithObjects:(NSArray *)objects db:(FMDatabase *)db;

- (BOOL)dropTable:(VVORMClass *)ormClass db:(FMDatabase *)db;

- (BOOL)createTable:(VVORMClass *)ormClass db:(FMDatabase *)db;

@end

@interface VVReferenceMapper ()

@property(nonatomic, strong) VVNameBuilder *nameBuilder;
@property(nonatomic, strong) NSMutableDictionary *registedORMClasses;
@property(nonatomic, strong) NSMutableDictionary *registedORMClazzs;

@end

@implementation VVReferenceMapper

+ (NSString *)ignorePrefixName {
    return nil;
}

+ (NSString *)ignoreSuffixName {
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.registedORMClazzs = [NSMutableDictionary dictionary];
        self.registedORMClasses = [NSMutableDictionary dictionary];
        VVNameBuilder *nameBuilder = [[VVNameBuilder alloc] init];
        Class clazz = self.class;
        nameBuilder.ignorePrefixName = [clazz ignorePrefixName];
        nameBuilder.ignoreSuffixName = [clazz ignoreSuffixName];
        self.nameBuilder = nameBuilder;
    }
    return self;
}

#pragma mark group methods

- (NSNumber *)max:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self max:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self min:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self avg:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self total:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self sum:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

#pragma mark exists method

- (NSNumber *)existsObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClass:object db:db error:error]) {
        return nil;
    }
    VVConditionModel *condition = nil;
    if (object.rowid) {
        condition = [object.ormClass rowidCondition:object];
    } else if (object.ormClass.hasIdentificationAttributes) {
        condition = [object.ormClass uniqueCondition:object];
    } else {
        return nil;
    }
    NSNumber *count = [self count:object.ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    if (!count) {
        return nil;
    } else if ([count isEqualToNumber:@0]) {
        return @NO;
    } else {
        return @YES;
    }
}

#pragma mark count methods

- (NSNumber *)count:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *count = [self count:ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return count;
}

#pragma mark[fetch methods

- (NSMutableArray *)findObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSMutableArray *list = [self find:ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return list;
}

#pragma mark save methods

- (BOOL)saveObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClasses:objects db:db error:error]) {
        return NO;
    }

    for (NSObject *targetObject in objects) {
        [self insertOrUpdate:targetObject db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark delete methods

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    [self deleteFrom:ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return NO;
    }

    return YES;
}

- (BOOL)deleteObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClasses:objects db:db error:error]) {
        return NO;
    }
    [self updateRowidWithObjects:objects db:db];
    if ([self hadError:db error:error]) {
        return NO;
    }

    for (NSObject *targetObject in objects) {
        [self deleteFrom:targetObject db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    for (NSObject *targetObject in objects) {
        targetObject.rowid = nil;
    }

    return YES;
}

#pragma mark common

- (BOOL)updateORMClasses:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    for (NSObject *object in objects) {
        if (![self updateORMClass:object db:db error:error]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateORMClass:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (object.ormClass) {
        return YES;
    }
    VVORMClass *ormClass = [self ormWithClazz:[object class] db:db error:error];
    if (!ormClass) {
        return NO;
    }
    object.ormClass = ormClass;
    return YES;
}

// 初始化或者更新数据库表、数据结构等
- (VVORMClass *)ormWithClazz:(Class)clazz db:(FMDatabase *)db error:(NSError **)error {
    VVORMClass *ormClass = [self ormClass:clazz];
    if (!ormClass) {
        return nil;
    }
    if (ormClass.isObjectClazz) {
        [self registerORMClass:ormClass db:db error:error];
        if ([self hadError:db error:nil]) {
            return nil;
        }
    }
    return ormClass;
}

- (BOOL)hadError:(FMDatabase *)db error:(NSError **)error {
    if ([db hadError]) {
        return YES;
    } else if (error) {
        if (*error) {
            return YES;
        }
    }
    return NO;
}


- (VVORMClass *)ormClass:(Class)clazz {
    if (clazz == NULL) {
        return nil;
    }

    Class targetClazz = NULL;
    VVClazz *vvclazz = [VVClazz vvclazzWithClazz:clazz];
    if (vvclazz.isObjectClazz) {
        targetClazz = clazz;
    } else {
        targetClazz = vvclazz.superClazz;
    }

    VVORMClass *ormClass = self.registedORMClazzs[NSStringFromClass(targetClazz)];
    if (!ormClass) {
        ormClass = [[VVORMClass alloc] initWithClazz:targetClazz osclazz:vvclazz nameBuilder:self.nameBuilder];
        self.registedORMClazzs[NSStringFromClass(targetClazz)] = ormClass;
    }
    return ormClass;

}

- (void)setRegistedORMClassFlag:(VVORMClass *)ormClass {
    self.registedORMClasses[ormClass.clazzName] = @(YES);
}

- (void)setUnRegistedORMClassFlag:(VVORMClass *)ormClass {
    [self.registedORMClasses removeObjectForKey:ormClass.clazzName];
}

- (void)setUnRegistedAllRuntimeFlag {
    for (NSString *key in self.registedORMClasses.allKeys) {
        [self.registedORMClasses removeObjectForKey:key];
    }
}

- (BOOL)registerORMClass:(VVORMClass *)ormClass db:(FMDatabase *)db error:(NSError **)error {
    NSNumber *registed = self.registedORMClasses[ormClass.clazzName];
    if (registed) {
        return YES;
    }

    if (ormClass.isObjectClazz) {
        [self createTable:ormClass db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        if (ormClass.clazz == [VVORMClass class]) {
            return YES;
        }
        if (ormClass.clazz == [VVPropertyInfo class]) {
            return YES;
        }
        if (![self updateORMClass:ormClass db:db error:error]) {
            return NO;
        }
        [self updateRowid:ormClass db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        [self saveObjects:@[ormClass] db:db error:error];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    self.registedORMClasses[ormClass.clazzName] = @YES;
    return YES;
}

- (BOOL)unRegisterORMClass:(VVORMClass *)ormClass db:(FMDatabase *)db error:(NSError **)error {
    NSNumber *registed = self.registedORMClasses[ormClass.clazzName];
    if (!registed.boolValue) {
        return YES;
    }
    [self dropTable:ormClass db:db];
    if ([self hadError:db error:error]) {
        return NO;
    }
    return YES;
}

@end
