//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVReferenceMapper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>

#import "VVModelInterface.h"
#import "VVORMRelationship.h"
#import "VVConditionModel.h"
#import "VVORMClass.h"
#import "VVORMProperty.h"
#import "VVNameBuilder.h"
#import "VVClazz.h"
#import "VVNotificationCenter.h"
#import "NSObject+VVTabel.h"
#import "VVReferenceConditionModel.h"

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

- (NSMutableArray *)select:(VVORMClass *)ormClass condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (void)updateSimpleValueWithObject:(NSObject *)object db:(FMDatabase *)db;

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db;

- (NSMutableArray *)relationshipObjectsWithObject:(NSObject *)object attribute:(VVORMProperty *)attribute relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db;

- (BOOL)insertRelationshipObjectsWithRelationshipObjects:(NSArray *)relationshipObjects db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithObject:(NSObject *)object attribute:(VVORMProperty *)attribute relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithRelationshipObject:(VVORMRelationship *)relationshipObject db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithFromObject:(NSObject *)object relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithToObject:(NSObject *)object relationshipORMClass:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db;

- (NSMutableArray *)relationshipObjectsWithToObject:(NSObject *)toObject relationshipRuntime:(VVORMClass *)relationshipORMClass db:(FMDatabase *)db;

- (void)updateRowid:(NSObject *)object db:(FMDatabase *)db;

- (void)updateRowidWithObjects:(NSArray *)objects db:(FMDatabase *)db;

- (BOOL)dropTable:(VVORMClass *)ormClass db:(FMDatabase *)db;

- (BOOL)createTable:(VVORMClass *)ormClass db:(FMDatabase *)db;

@end


@interface VVProcessingModel : NSObject

@property(nonatomic, strong) NSObject *targetObject;
@property(nonatomic, strong) VVORMProperty *attribute;
@property(nonatomic, strong) NSMutableArray *relationshipObjects;

@end

@implementation VVProcessingModel

@end

@interface VVProcessingInAttributeModel : NSObject

@property(nonatomic, strong) NSObject *targetObjectInAttribute;
@property(nonatomic, strong) VVORMRelationship *parentRelationship;

@end

@implementation VVProcessingInAttributeModel

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
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self max:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self min:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self avg:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *value = [self total:ormClass columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
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
        condition = [object.VVORMClass rowidCondition:object];
    } else if (object.VVORMClass.hasIdentificationAttributes) {
        condition = [object.VVORMClass uniqueCondition:object];
    } else {
        return nil;
    }
    NSNumber *count = [self count:object.VVORMClass condition:condition db:db];
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
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSNumber *count = [self count:ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return count;
}

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClass:object db:db error:error]) {
        return nil;
    }
    NSNumber *count = [self referencedCount:object db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return count;
}


#pragma mark fetch methods

- (NSObject *)refreshObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (!object) {
        return nil;
    }
    if (![self updateORMClass:object db:db error:error]) {
        return nil;
    }
    return [self refreshObjectSub:object db:db error:error];
}

- (NSObject *)refreshObjectSub:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    VVConditionModel *condition = nil;
    if (object.rowid) {
        condition = [object.VVORMClass rowidCondition:object];
    } else if (object.VVORMClass.hasIdentificationAttributes) {
        condition = [object.VVORMClass uniqueCondition:object];
    } else {
        return nil;
    }
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    NSMutableArray *list = [self select:object.VVORMClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    list = [self fetchObjectsSub:list refreshing:YES db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return list.firstObject;
}

- (NSMutableArray *)fetchObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return nil;
    }
    VVORMClass *ormClass = [self ormWithClazz:clazz db:db error:error];
    NSMutableArray *list = [self select:ormClass condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    list = [self fetchObjectsSub:list refreshing:NO db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return list;
}

- (NSMutableArray *)fetchReferencingObjectsWithToObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClass:object db:db error:error]) {
        return nil;
    }
    [self updateRowid:object db:db];
    if ([db hadError]) {
        return nil;
    }
    if (!object.rowid) {
        return nil;
    }
    VVORMClass *relationshipRuntime = [self ormWithClazz:[VVORMRelationship class] db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    NSMutableArray *relationshipObjects = [self relationshipObjectsWithToObject:object relationshipRuntime:relationshipRuntime db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    NSMutableArray *list = [NSMutableArray array];
    for (VVORMRelationship *relationshipObject in relationshipObjects) {
        Class targetClazz = NSClassFromString(relationshipObject.fromClassName);
        if (targetClazz) {
            VVORMClass *ormClass = [self ormWithClazz:targetClazz db:db error:error];
            if ([self hadError:db error:error]) {
                return nil;
            }
            if (ormClass.isObjectClazz) {
                NSObject *targetObject = [ormClass object];
                targetObject.VVORMClass = ormClass;
                targetObject.rowid = relationshipObject.fromRowid;
                targetObject = [self refreshObjectSub:targetObject db:db error:error];
                if ([self hadError:db error:error]) {
                    return nil;
                }
                if (*error) {
                    return nil;
                }
                if (targetObject) {
                    [list addObject:targetObject];
                }
            }
        }
    }
    return list;
}

- (NSMutableArray *)fetchObjectsSub:(NSArray *)objects refreshing:(BOOL)refreshing db:(FMDatabase *)db error:(NSError **)error {
    NSMutableDictionary *processedObjects = [NSMutableDictionary dictionary];
    NSMutableArray *targetObjects = [NSMutableArray array];
    for (NSObject *object in objects) {
        if (![processedObjects valueForKey:object.VVHashForSave]) {
            [processedObjects setValue:object forKey:object.VVHashForSave];
            if (object.rowid && object.VVORMClass.hasRelationshipAttributes) {
                [targetObjects addObject:object];
            }
        }
    }
    VVORMClass *relationshipRuntime = [self ormWithClazz:[VVORMRelationship class] db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    while (targetObjects.count > 0) {

        // each object
        NSObject *targetObject = [targetObjects lastObject];

        // each object-attribute
        for (VVORMProperty *attribute in targetObject.VVORMClass.relationshipAttributes) {
            BOOL ignoreFetch = NO;
            if (attribute.fetchOnRefreshingAttribute) {
                if (!(refreshing && [objects containsObject:targetObject])) {
                    ignoreFetch = YES;
                }
            }
            if (!ignoreFetch) {
                VVProcessingModel *processingObject = [[VVProcessingModel alloc] init];
                processingObject.targetObject = targetObject;
                processingObject.attribute = attribute;
                processingObject.relationshipObjects = [self relationshipObjectsWithObject:targetObject attribute:attribute relationshipORMClass:relationshipRuntime db:db];
                for (VVORMRelationship *relationshipObject in processingObject.relationshipObjects) {
                    Class attributeClazz = NSClassFromString(relationshipObject.toClassName);
                    VVORMClass *ormClass = [self ormWithClazz:attributeClazz db:db error:error];
                    if ([self hadError:db error:error]) {
                        return nil;
                    }
                    if (ormClass.isObjectClazz) {
                        NSObject *object = [ormClass object];
                        object.rowid = relationshipObject.toRowid;
                        NSObject *processedObject = [processedObjects valueForKey:object.VVHashForFetch];
                        if (processedObject) {
                            relationshipObject.attributeFromObject = targetObject;
                            relationshipObject.attributeValue = processedObject;
                        } else {
                            relationshipObject.attributeFromObject = targetObject;
                            relationshipObject.attributeValue = object;
                            object.VVORMClass = ormClass;
                            if (object.VVORMClass.hasRelationshipAttributes) {
                                [targetObjects addObject:object];
                            }
                            [processedObjects setValue:object forKey:object.VVHashForFetch];
                        }

                    } else if (ormClass.isArrayClazz) {
                        NSMutableArray *objects = [NSMutableArray array];
                        NSMutableArray *keys = [NSMutableArray array];
                        for (VVORMRelationship *child in processingObject.relationshipObjects) {
                            if ([child.attributeParentLevel isEqualToNumber:relationshipObject.attributeLevel]) {
                                if ([child.attributeParentSequence isEqualToNumber:relationshipObject.attributeSequence]) {
                                    if (child.attributeValue) {
                                        if (child.attributeKey) {
                                            [keys addObject:child.attributeKey];
                                        } else {
                                            [keys addObject:[NSNull null]];
                                        }
                                        [objects addObject:child.attributeValue];
                                    }
                                }
                            }
                        }
                        NSObject *value = [ormClass objectWithObjects:objects keys:keys initializingOptions:relationshipObject.attributeKey];
                        relationshipObject.attributeFromObject = targetObject;
                        relationshipObject.attributeValue = value;
                    } else if (ormClass.isSimpleValueClazz) {
                        Class clazz = NSClassFromString(relationshipObject.toClassName);
                        if (clazz) {
                            relationshipObject.attributeFromObject = targetObject;
                        }
                    }

                    if (ormClass) {
                        if (relationshipObject == processingObject.relationshipObjects.lastObject) {
                            [targetObject setValue:relationshipObject.attributeValue forKey:attribute.name];
                        }
                    }
                }
            }
        }
        [targetObjects removeObject:targetObject];
    }


    // fetch objects
    NSArray *allValues = processedObjects.allValues;
    for (NSObject *targetObject in allValues) {
        [self updateSimpleValueWithObject:targetObject db:db];
        if ([self hadError:db error:error]) {
            return nil;
        }
    }

    for (NSObject *targetObject in allValues) {
        if (targetObject.VVORMClass.modelDidLoad) {
            if ([targetObject respondsToSelector:@selector(VVModelDidLoad)]) {
                [targetObject performSelector:@selector(VVModelDidLoad) withObject:nil];
            }
        }
    }

    return [NSMutableArray arrayWithArray:objects];
}


#pragma mark save methods

- (BOOL)saveObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateORMClasses:objects db:db error:error]) {
        return NO;
    }
    if ([self hadError:db error:error]) {
        return NO;
    }
    return [self saveObjectsSub:objects db:db error:error];
}

- (BOOL)saveObjectsSub:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    NSMutableArray *processingObjects = [NSMutableArray array];
    NSMutableDictionary *processedObjects = [NSMutableDictionary dictionary];
    NSMutableArray *targetObjects = [NSMutableArray array];
    for (NSObject *object in objects) {
        if (object.VVORMClass.hasRelationshipAttributes) {
            [targetObjects addObjectsFromArray:objects];
        } else {
            if (![processedObjects valueForKey:object.VVHashForSave]) {
                [processedObjects setValue:object forKey:object.VVHashForSave];
            }
        }
    }
    while (targetObjects.count > 0) {
        NSObject *targetObject = [targetObjects lastObject];
        if (![processedObjects valueForKey:targetObject.VVHashForSave]) {
            [processedObjects setValue:targetObject forKey:targetObject.VVHashForSave];
            for (VVORMProperty *attribute in targetObject.VVORMClass.relationshipAttributes) {
                NSObject *targetObjectInAttribute = [targetObject valueForKey:attribute.name];
                VVProcessingModel *processingObject = [[VVProcessingModel alloc] init];
                processingObject.targetObject = targetObject;
                processingObject.attribute = attribute;
                if (targetObjectInAttribute) {

                    NSMutableArray *processingInAttributeObjects = [NSMutableArray array];
                    NSMutableArray *allRelationshipObjects = [NSMutableArray array];

                    VVORMClass *ormClass;
                    if (attribute.clazz) {
                        ormClass = [self ormWithClazz:attribute.clazz db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                    } else {
                        ormClass = [self ormWithClazz:[targetObjectInAttribute class] db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                    }
                    if (ormClass.isArrayClazz) {
                        VVORMRelationship *topRelationshipObject = [[VVORMRelationship alloc] init];
                        topRelationshipObject.fromClassName = targetObject.VVORMClass.clazzName;
                        topRelationshipObject.fromTableName = targetObject.VVORMClass.tableName;
                        topRelationshipObject.fromAttributeName = attribute.name;
                        topRelationshipObject.fromRowid = @0;
                        topRelationshipObject.toClassName = attribute.clazzName;
                        topRelationshipObject.toTableName = nil;
                        topRelationshipObject.toRowid = @0;
                        topRelationshipObject.attributeValue = nil;
                        topRelationshipObject.attributeLevel = @1;
                        topRelationshipObject.attributeSequence = @1;
                        topRelationshipObject.attributeParentLevel = @0;
                        topRelationshipObject.attributeParentSequence = @0;
                        topRelationshipObject.attributeFromObject = targetObject;
                        topRelationshipObject.attributeToObject = [targetObject valueForKey:attribute.name];
                        topRelationshipObject.attributeToObject.VVORMClass = ormClass;
                        topRelationshipObject.attributeKey = nil;
                        [allRelationshipObjects addObject:topRelationshipObject];

                        VVProcessingInAttributeModel *processingInAttributeObject = [[VVProcessingInAttributeModel alloc] init];
                        processingInAttributeObject.parentRelationship = topRelationshipObject;
                        processingInAttributeObject.targetObjectInAttribute = targetObjectInAttribute;
                        [processingInAttributeObjects addObject:processingInAttributeObject];

                    } else if (ormClass.isObjectClazz || ormClass.isSimpleValueClazz) {
                        VVProcessingInAttributeModel *processingInAttributeObject = [[VVProcessingInAttributeModel alloc] init];
                        processingInAttributeObject.parentRelationship = nil;
                        processingInAttributeObject.targetObjectInAttribute = targetObjectInAttribute;
                        [processingInAttributeObjects addObject:processingInAttributeObject];

                    }

                    while (processingInAttributeObjects.count > 0) {
                        VVProcessingInAttributeModel *processingInAttributeObject = [processingInAttributeObjects lastObject];
                        [processingInAttributeObjects removeLastObject];

                        NSMutableArray *relationshipObjects = [NSMutableArray array];
                        NSEnumerator *enumerator = nil;
                        NSArray *keys = nil;
                        NSInteger attributeSequence = 1;
                        NSNumber *attributeLevel = @([processingInAttributeObject.parentRelationship.attributeLevel unsignedIntegerValue] + 1);
                        NSNumber *attributeParentLevel = processingInAttributeObject.parentRelationship.attributeLevel;
                        NSNumber *attributeParentSequence = processingInAttributeObject.parentRelationship.attributeSequence;
                        if (!attributeParentLevel) {
                            attributeParentLevel = @0;
                        }
                        if (!attributeParentSequence) {
                            attributeParentSequence = @0;
                        }

                        VVORMClass *ormClass = [self ormWithClazz:processingInAttributeObject.targetObjectInAttribute.class db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                        if (ormClass.isRelationshipClazz) {
                            processingInAttributeObject.targetObjectInAttribute.VVORMClass = ormClass;
                            enumerator = [processingInAttributeObject.targetObjectInAttribute.VVORMClass objectEnumeratorWithObject:processingInAttributeObject.targetObjectInAttribute];
                            keys = [processingInAttributeObject.targetObjectInAttribute.VVORMClass keysWithObject:processingInAttributeObject.targetObjectInAttribute];
                        }
                        for (NSObject *attributeObjectInEnumerator in enumerator) {
                            Class attributeClazzInEnumerator = [attributeObjectInEnumerator class];
                            VVORMClass *attributeRuntimeInEnumerator = [self ormWithClazz:attributeClazzInEnumerator db:db error:error];
                            if ([self hadError:db error:error]) {
                                return NO;
                            }
                            if (attributeRuntimeInEnumerator) {
                                if (attributeRuntimeInEnumerator.isRelationshipClazz) {
                                    attributeObjectInEnumerator.VVORMClass = attributeRuntimeInEnumerator;
                                }
                                NSString *attributeObjectClassName = nil;
                                NSString *attributeObjectTableName = nil;
                                NSObject *attributeObject = nil;
                                NSObject *attributeValue = nil;
                                if (attributeRuntimeInEnumerator.isObjectClazz) {
                                    attributeObject = attributeObjectInEnumerator;
                                    attributeObjectTableName = [self.nameBuilder tableName:[attributeObjectInEnumerator class]];;
                                    attributeObjectClassName = attributeRuntimeInEnumerator.clazzName;
                                } else if (attributeRuntimeInEnumerator.isArrayClazz) {
                                    attributeObject = attributeObjectInEnumerator;
                                    attributeObjectClassName = attributeRuntimeInEnumerator.clazzName;
                                } else if (attributeRuntimeInEnumerator.isSimpleValueClazz) {
                                    attributeObject = attributeObjectInEnumerator;
                                    attributeObjectClassName = attributeRuntimeInEnumerator.clazzName;
                                    attributeValue = attributeObjectInEnumerator;
                                }
                                VVORMRelationship *relationshipObject = [[VVORMRelationship alloc] init];
                                relationshipObject.fromClassName = targetObject.VVORMClass.clazzName;
                                relationshipObject.fromTableName = targetObject.VVORMClass.tableName;
                                relationshipObject.fromAttributeName = attribute.name;
                                relationshipObject.fromRowid = @0;
                                relationshipObject.toClassName = attributeObjectClassName;
                                relationshipObject.toTableName = attributeObjectTableName;
                                relationshipObject.toRowid = @0;
                                relationshipObject.attributeValue = attributeValue;
                                relationshipObject.attributeLevel = attributeLevel;
                                relationshipObject.attributeSequence = @(attributeSequence);
                                relationshipObject.attributeParentLevel = attributeParentLevel;
                                relationshipObject.attributeParentSequence = attributeParentSequence;
                                relationshipObject.attributeFromObject = targetObject;
                                relationshipObject.attributeToObject = attributeObject;
                                if (keys) {
                                    relationshipObject.attributeKey = keys[attributeSequence - 1];
                                } else {
                                    relationshipObject.attributeKey = nil;
                                }
                                if (attributeRuntimeInEnumerator.isRelationshipClazz) {
                                    relationshipObject.attributeToObject.VVORMClass = attributeRuntimeInEnumerator;
                                }
                                [relationshipObjects addObject:relationshipObject];
                                [allRelationshipObjects addObject:relationshipObject];
                                attributeSequence++;
                            }
                        }
                        for (VVORMRelationship *relationshipObject in relationshipObjects) {
                            if (relationshipObject.attributeToObject.VVORMClass.isArrayClazz) {
                                VVProcessingInAttributeModel *processingInAttributeObject = [[VVProcessingInAttributeModel alloc] init];
                                processingInAttributeObject.parentRelationship = relationshipObject;
                                processingInAttributeObject.targetObjectInAttribute = relationshipObject.attributeToObject;
                                [processingInAttributeObjects addObject:processingInAttributeObject];

                            } else if (relationshipObject.attributeToObject.VVORMClass.isObjectClazz) {
                                [targetObjects addObject:relationshipObject.attributeToObject];
                            }
                        }
                    }
                    processingObject.relationshipObjects = allRelationshipObjects;
                }
                [processingObjects addObject:processingObject];
            }
            [targetObjects removeObject:targetObject];
        } else {
            [targetObjects removeObject:targetObject];
        }
    }

    // save objects
    NSArray *allValues = processedObjects.allValues;
    for (NSObject *targetObject in allValues) {
        [self insertOrUpdate:targetObject db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    // save relationship
    VVORMClass *relationshipRuntime = [self ormWithClazz:[VVORMRelationship class] db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    for (VVProcessingModel *processingObject in processingObjects) {
        for (VVORMRelationship *relationshipObject in processingObject.relationshipObjects) {
            relationshipObject.VVORMClass = relationshipRuntime;
            relationshipObject.fromRowid = relationshipObject.attributeFromObject.rowid;
            if (relationshipObject.attributeToObject) {
                if (relationshipObject.toTableName) {
                    relationshipObject.toRowid = relationshipObject.attributeToObject.rowid;
                }
            }
        }
    }
    for (VVProcessingModel *processingObject in processingObjects) {
        for (VVORMRelationship *relationshipObject in processingObject.relationshipObjects) {
            [self deleteRelationshipObjectsWithRelationshipObject:relationshipObject db:db];
            if ([self hadError:db error:error]) {
                return NO;
            }
        }
        NSMutableArray *relationshipObjects = [self relationshipObjectsWithObject:processingObject.targetObject attribute:processingObject.attribute relationshipORMClass:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        if (!processingObject.attribute.weakReferenceAttribute) {
            for (VVORMRelationship *relationshipObject in relationshipObjects) {
                if (relationshipObject.toTableName) {
                    Class targetClazz = NSClassFromString(relationshipObject.toClassName);
                    VVORMClass *targetRuntime = [self ormWithClazz:targetClazz db:db error:error];
                    if ([self hadError:db error:error]) {
                        return NO;
                    }
                    if (targetRuntime.isObjectClazz) {
                        NSObject *object = [targetRuntime object];
                        object.VVORMClass = targetRuntime;
                        object.rowid = relationshipObject.toRowid;
                        object = [self refreshObjectSub:object db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                        if (object) {
                            [self deleteObjectsSub:@[object] db:db error:error];
                            if ([self hadError:db error:error]) {
                                return NO;
                            }
                        }
                    }
                }
            }
        }
        [self deleteRelationshipObjectsWithObject:processingObject.targetObject attribute:processingObject.attribute relationshipORMClass:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        [self insertRelationshipObjectsWithRelationshipObjects:processingObject.relationshipObjects db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    for (NSObject *targetObject in allValues) {
        if (targetObject.VVORMClass.modelDidSave) {
            if ([targetObject respondsToSelector:@selector(VVModelDidSave)]) {
                [targetObject performSelector:@selector(VVModelDidSave) withObject:nil];
            }
        }
        if (!self.disableNotifications) {
            if (targetObject.VVORMClass.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeSaved];
            }
        }
    }

    for (NSObject *targetObject in objects) {
        if (!self.disableNotifications) {
            if (targetObject.VVORMClass.notification && !targetObject.VVORMClass.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeSaved];
            }
        }
    }

    return YES;
}


#pragma mark delete methods

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionORMClass:condition db:db error:error]) {
        return NO;
    }
    NSArray *objects = [self fetchObjects:clazz condition:condition db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    [self deleteObjectsSub:objects db:db error:error];
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
    objects = [self fetchObjectsSub:objects refreshing:YES db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    [self deleteObjectsSub:objects db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteObjectsSub:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    NSMutableDictionary *processedObjects = [NSMutableDictionary dictionary];
    NSMutableArray *targetObjects = [NSMutableArray array];
    for (NSObject *targetObject in objects) {
        if (targetObject.rowid) {
            if (targetObject.VVORMClass.hasRelationshipAttributes) {
                [targetObjects addObject:targetObject];
            } else {
                if (![processedObjects valueForKey:targetObject.VVHashForSave]) {
                    [processedObjects setValue:targetObject forKey:targetObject.VVHashForSave];
                }
            }
        }
    }
    while (targetObjects.count > 0) {
        NSObject *targetObject = [targetObjects lastObject];
        if (![processedObjects valueForKey:targetObject.VVHashForSave]) {
            [processedObjects setValue:targetObject forKey:targetObject.VVHashForSave];
            for (VVORMProperty *attribute in targetObject.VVORMClass.relationshipAttributes) {
                if (!attribute.weakReferenceAttribute) {
                    NSObject *tagetObjectInAttribute = [targetObject valueForKey:attribute.name];
                    if (tagetObjectInAttribute) {
                        NSMutableArray *tagetObjectsInAttribute = [NSMutableArray array];
                        [tagetObjectsInAttribute addObject:tagetObjectInAttribute];

                        while (tagetObjectsInAttribute.count > 0) {
                            NSObject *tagetObjectInAttribute = [tagetObjectsInAttribute lastObject];
                            [tagetObjectsInAttribute removeLastObject];
                            [self updateORMClass:tagetObjectInAttribute db:db error:error];
                            if ([self hadError:db error:error]) {
                                return NO;
                            }
                            if (tagetObjectInAttribute.VVORMClass.isRelationshipClazz) {
                                NSEnumerator *enumerator = [tagetObjectInAttribute.VVORMClass objectEnumeratorWithObject:tagetObjectInAttribute];
                                for (NSObject *tagetObjectInEnumeratorInAttribute in enumerator) {
                                    VVORMClass *ormClass = [self ormWithClazz:[tagetObjectInEnumeratorInAttribute class] db:db error:error];
                                    if (ormClass.isObjectClazz) {
                                        tagetObjectInEnumeratorInAttribute.VVORMClass = ormClass;
                                        [targetObjects addObject:tagetObjectInEnumeratorInAttribute];
                                    } else if (ormClass.isArrayClazz) {
                                        [tagetObjectsInAttribute addObject:tagetObjectInEnumeratorInAttribute];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            [targetObjects removeObject:targetObject];
        } else {
            [targetObjects removeObject:targetObject];
        }
    }

    // delete objects
    VVORMClass *relationshipRuntime = [self ormWithClazz:[VVORMRelationship class] db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    // delete objects
    NSArray *allValues = processedObjects.allValues;
    for (NSObject *targetObject in allValues) {
        [self deleteFrom:targetObject db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        [self deleteRelationshipObjectsWithFromObject:targetObject relationshipORMClass:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    // referencing objects
    NSMutableDictionary *referencingObjects = [NSMutableDictionary dictionary];
    for (NSObject *targetObject in allValues) {
        NSMutableArray *relationshipObjects = [self relationshipObjectsWithToObject:targetObject relationshipRuntime:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        for (VVORMRelationship *relationshipObject in relationshipObjects) {
            Class targetClazz = NSClassFromString(relationshipObject.fromClassName);
            if (targetClazz) {
                VVORMClass *ormClass = [self ormWithClazz:targetClazz db:db error:error];
                if ([self hadError:db error:error]) {
                    return NO;
                }
                if (ormClass.isObjectClazz && ormClass.cascadeNotification) {
                    NSObject *referencingObject = [ormClass object];
                    referencingObject.VVORMClass = ormClass;
                    referencingObject.rowid = relationshipObject.fromRowid;
                    [referencingObjects setValue:referencingObject forKey:referencingObject.VVHashForSave];
                }
            }
        }
        [self deleteRelationshipObjectsWithToObject:targetObject relationshipORMClass:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    // delete events and notifications
    for (NSObject *targetObject in allValues) {
        if (targetObject.VVORMClass.modelDidDelete) {
            if ([targetObject respondsToSelector:@selector(VVModelDidDelete)]) {
                [targetObject performSelector:@selector(VVModelDidDelete) withObject:nil];
            }
        }
        if (!self.disableNotifications) {
            if (targetObject.VVORMClass.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeDeleted];
            }
        }
    }

    // delete cascade notifications
    for (NSObject *targetObject in objects) {
        if (!self.disableNotifications) {
            if (targetObject.VVORMClass.notification && !targetObject.VVORMClass.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeDeleted];
            }
        }
    }

    // save cascade notifications
    for (NSObject *targetObject in referencingObjects.allValues) {
        NSObject *latestObject = [self refreshObjectSub:targetObject db:db error:error];
        if ([self hadError:db error:error]) {
            return NO;
        }
        VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
        [center postVVNotification:latestObject notificationType:VVDBNotificationTypeSaved];
    }


    for (NSObject *targetObject in allValues) {
        targetObject.rowid = nil;
    }


    return YES;
}


#pragma mark common

- (BOOL)updateConditionORMClass:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (condition.reference.from) {
        if (![self updateORMClass:condition.reference.from db:db error:error]) {
            return NO;
        }
    }
    if (condition.reference.to) {
        if (![self updateORMClass:condition.reference.to db:db error:error]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateORMClasses:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    for (NSObject *object in objects) {
        if (![self updateORMClass:object db:db error:error]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateORMClass:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (object.VVORMClass) {
        return YES;
    }
    VVORMClass *ormClass = [self ormWithClazz:[object class] db:db error:error];
    if (!ormClass) {
        return NO;
    }
    object.VVORMClass = ormClass;
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
        if (ormClass.clazz == [VVORMRelationship class]) {
            return YES;
        }
        if (ormClass.clazz == [VVORMClass class]) {
            return YES;
        }
        if (ormClass.clazz == [VVORMProperty class]) {
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
    [self deleteObjects:ormClass.clazz condition:nil db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    [self dropTable:ormClass db:db];
    if ([self hadError:db error:error]) {
        return NO;
    }
    return YES;
}

@end
