//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVReferenceMapper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>

#import "VVModelInterface.h"
#import "VVRelationshipModel.h"
#import "VVConditionModel.h"
#import "VVRuntime.h"
#import "VVRuntimeProperty.h"
#import "VVNameBuilder.h"
#import "VVClazz.h"
#import "VVNotificationCenter.h"
#import "NSObject+VVTabel.h"
#import "VVReferenceConditionModel.h"

@interface VVModelMapper (Protected)

- (NSNumber *)avg:(VVRuntime *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)total:(VVRuntime *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)sum:(VVRuntime *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)min:(VVRuntime *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)max:(VVRuntime *)runtime columnName:(NSString *)columnName condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSNumber *)count:(VVRuntime *)runtime condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (BOOL)insertOrUpdate:(NSObject *)object db:(FMDatabase *)db;

- (BOOL)deleteFrom:(NSObject *)object db:(FMDatabase *)db;

- (BOOL)deleteFrom:(VVRuntime *)runtime condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (NSMutableArray *)select:(VVRuntime *)runtime condition:(VVConditionModel *)condition db:(FMDatabase *)db;

- (void)updateSimpleValueWithObject:(NSObject *)object db:(FMDatabase *)db;

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db;

- (NSMutableArray *)relationshipObjectsWithObject:(NSObject *)object attribute:(VVRuntimeProperty *)attribute relationshipRuntime:(VVRuntime *)relationshipRuntime db:(FMDatabase *)db;

- (BOOL)insertRelationshipObjectsWithRelationshipObjects:(NSArray *)relationshipObjects db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithObject:(NSObject *)object attribute:(VVRuntimeProperty *)attribute relationshipRuntime:(VVRuntime *)relationshipRuntime db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithRelationshipObject:(VVRelationshipModel *)relationshipObject db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithFromObject:(NSObject *)object relationshipRuntime:(VVRuntime *)relationshipRuntime db:(FMDatabase *)db;

- (BOOL)deleteRelationshipObjectsWithToObject:(NSObject *)object relationshipRuntime:(VVRuntime *)relationshipRuntime db:(FMDatabase *)db;

- (NSMutableArray *)relationshipObjectsWithToObject:(NSObject *)toObject relationshipRuntime:(VVRuntime *)relationshipRuntime db:(FMDatabase *)db;

- (void)updateRowid:(NSObject *)object db:(FMDatabase *)db;

- (void)updateRowidWithObjects:(NSArray *)objects db:(FMDatabase *)db;

- (BOOL)dropTable:(VVRuntime *)runtime db:(FMDatabase *)db;

- (BOOL)createTable:(VVRuntime *)runtime db:(FMDatabase *)db;

@end


@interface BZProcessingModel : NSObject

@property(nonatomic, strong) NSObject *targetObject;
@property(nonatomic, strong) VVRuntimeProperty *attribute;
@property(nonatomic, strong) NSMutableArray *relationshipObjects;

@end

@implementation BZProcessingModel

@end

@interface BZProcessingInAttributeModel : NSObject

@property(nonatomic, strong) NSObject *targetObjectInAttribute;
@property(nonatomic, strong) VVRelationshipModel *parentRelationship;

@end

@implementation BZProcessingInAttributeModel

@end

@interface VVReferenceMapper ()
@property(nonatomic, strong) VVNameBuilder *nameBuilder;
@property(nonatomic, strong) NSMutableDictionary *registedClazzes;
@property(nonatomic, strong) NSMutableDictionary *registedRuntimes;
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
        self.registedRuntimes = [NSMutableDictionary dictionary];
        self.registedClazzes = [NSMutableDictionary dictionary];
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
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *value = [self max:runtime columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)min:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *value = [self min:runtime columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)avg:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *value = [self avg:runtime columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)total:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *value = [self total:runtime columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}

- (NSNumber *)sum:(NSString *)columnName class:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *value = [self sum:runtime columnName:columnName condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return value;
}


#pragma mark exists method

- (NSNumber *)existsObject:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateRuntime:object db:db error:error]) {
        return nil;
    }
    VVConditionModel *condition = nil;
    if (object.rowid) {
        condition = [object.VVRuntime rowidCondition:object];
    } else if (object.VVRuntime.hasIdentificationAttributes) {
        condition = [object.VVRuntime uniqueCondition:object];
    } else {
        return nil;
    }
    NSNumber *count = [self count:object.VVRuntime condition:condition db:db];
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
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSNumber *count = [self count:runtime condition:condition db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    return count;
}

- (NSNumber *)referencedCount:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateRuntime:object db:db error:error]) {
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
    if (![self updateRuntime:object db:db error:error]) {
        return nil;
    }
    return [self refreshObjectSub:object db:db error:error];
}

- (NSObject *)refreshObjectSub:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    VVConditionModel *condition = nil;
    if (object.rowid) {
        condition = [object.VVRuntime rowidCondition:object];
    } else if (object.VVRuntime.hasIdentificationAttributes) {
        condition = [object.VVRuntime uniqueCondition:object];
    } else {
        return nil;
    }
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    NSMutableArray *list = [self select:object.VVRuntime condition:condition db:db];
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
    if (![self updateConditionRuntime:condition db:db error:error]) {
        return nil;
    }
    VVRuntime *runtime = [self runtimeWithClazz:clazz db:db error:error];
    NSMutableArray *list = [self select:runtime condition:condition db:db];
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
    if (![self updateRuntime:object db:db error:error]) {
        return nil;
    }
    [self updateRowid:object db:db];
    if ([db hadError]) {
        return nil;
    }
    if (!object.rowid) {
        return nil;
    }
    VVRuntime *relationshipRuntime = [self runtimeWithClazz:[VVRelationshipModel class] db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    NSMutableArray *relationshipObjects = [self relationshipObjectsWithToObject:object relationshipRuntime:relationshipRuntime db:db];
    if ([self hadError:db error:error]) {
        return nil;
    }
    NSMutableArray *list = [NSMutableArray array];
    for (VVRelationshipModel *relationshipObject in relationshipObjects) {
        Class targetClazz = NSClassFromString(relationshipObject.fromClassName);
        if (targetClazz) {
            VVRuntime *runtime = [self runtimeWithClazz:targetClazz db:db error:error];
            if ([self hadError:db error:error]) {
                return nil;
            }
            if (runtime.isObjectClazz) {
                NSObject *targetObject = [runtime object];
                targetObject.VVRuntime = runtime;
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
            if (object.rowid && object.VVRuntime.hasRelationshipAttributes) {
                [targetObjects addObject:object];
            }
        }
    }
    VVRuntime *relationshipRuntime = [self runtimeWithClazz:[VVRelationshipModel class] db:db error:error];
    if ([self hadError:db error:error]) {
        return nil;
    }
    while (targetObjects.count > 0) {

        // each object
        NSObject *targetObject = [targetObjects lastObject];
        // each object-attribute
        for (VVRuntimeProperty *attribute in targetObject.VVRuntime.relationshipAttributes) {
            BOOL ignoreFetch = NO;
            if (attribute.fetchOnRefreshingAttribute) {
                if (!(refreshing && [objects containsObject:targetObject])) {
                    ignoreFetch = YES;
                }
            }
            if (!ignoreFetch) {
                BZProcessingModel *processingObject = [[BZProcessingModel alloc] init];
                processingObject.targetObject = targetObject;
                processingObject.attribute = attribute;
                processingObject.relationshipObjects = [self relationshipObjectsWithObject:targetObject attribute:attribute relationshipRuntime:relationshipRuntime db:db];
                for (VVRelationshipModel *relationshipObject in processingObject.relationshipObjects) {
                    Class attributeClazz = NSClassFromString(relationshipObject.toClassName);
                    VVRuntime *runtime = [self runtimeWithClazz:attributeClazz db:db error:error];
                    if ([self hadError:db error:error]) {
                        return nil;
                    }
                    if (runtime.isObjectClazz) {
                        NSObject *object = [runtime object];
                        object.rowid = relationshipObject.toRowid;
                        NSObject *processedObject = [processedObjects valueForKey:object.VVHashForFetch];
                        if (processedObject) {
                            relationshipObject.attributeFromObject = targetObject;
                            relationshipObject.attributeValue = processedObject;
                        } else {
                            relationshipObject.attributeFromObject = targetObject;
                            relationshipObject.attributeValue = object;
                            object.VVRuntime = runtime;
                            if (object.VVRuntime.hasRelationshipAttributes) {
                                [targetObjects addObject:object];
                            }
                            [processedObjects setValue:object forKey:object.VVHashForFetch];
                        }

                    } else if (runtime.isArrayClazz) {
                        NSMutableArray *objects = [NSMutableArray array];
                        NSMutableArray *keys = [NSMutableArray array];
                        for (VVRelationshipModel *child in processingObject.relationshipObjects) {
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
                        NSObject *value = [runtime objectWithObjects:objects keys:keys initializingOptions:relationshipObject.attributeKey];
                        relationshipObject.attributeFromObject = targetObject;
                        relationshipObject.attributeValue = value;
                    } else if (runtime.isSimpleValueClazz) {
                        Class clazz = NSClassFromString(relationshipObject.toClassName);
                        if (clazz) {
                            relationshipObject.attributeFromObject = targetObject;
                        }
                    }

                    if (runtime) {
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
        if (targetObject.VVRuntime.modelDidLoad) {
            if ([targetObject respondsToSelector:@selector(VVModelDidLoad)]) {
                [targetObject performSelector:@selector(VVModelDidLoad) withObject:nil];
            }
        }
    }

    return [NSMutableArray arrayWithArray:objects];
}


#pragma mark save methods

- (BOOL)saveObjects:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateRuntimes:objects db:db error:error]) {
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
        if (object.VVRuntime.hasRelationshipAttributes) {
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
            for (VVRuntimeProperty *attribute in targetObject.VVRuntime.relationshipAttributes) {
                NSObject *targetObjectInAttribute = [targetObject valueForKey:attribute.name];
                BZProcessingModel *processingObject = [[BZProcessingModel alloc] init];
                processingObject.targetObject = targetObject;
                processingObject.attribute = attribute;
                if (targetObjectInAttribute) {

                    NSMutableArray *processingInAttributeObjects = [NSMutableArray array];
                    NSMutableArray *allRelationshipObjects = [NSMutableArray array];

                    VVRuntime *runtime;
                    if (attribute.clazz) {
                        runtime = [self runtimeWithClazz:attribute.clazz db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                    } else {
                        runtime = [self runtimeWithClazz:[targetObjectInAttribute class] db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                    }
                    if (runtime.isArrayClazz) {
                        VVRelationshipModel *topRelationshipObject = [[VVRelationshipModel alloc] init];
                        topRelationshipObject.fromClassName = targetObject.VVRuntime.clazzName;
                        topRelationshipObject.fromTableName = targetObject.VVRuntime.tableName;
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
                        topRelationshipObject.attributeToObject.VVRuntime = runtime;
                        topRelationshipObject.attributeKey = nil;
                        [allRelationshipObjects addObject:topRelationshipObject];

                        BZProcessingInAttributeModel *processingInAttributeObject = [[BZProcessingInAttributeModel alloc] init];
                        processingInAttributeObject.parentRelationship = topRelationshipObject;
                        processingInAttributeObject.targetObjectInAttribute = targetObjectInAttribute;
                        [processingInAttributeObjects addObject:processingInAttributeObject];

                    } else if (runtime.isObjectClazz || runtime.isSimpleValueClazz) {
                        BZProcessingInAttributeModel *processingInAttributeObject = [[BZProcessingInAttributeModel alloc] init];
                        processingInAttributeObject.parentRelationship = nil;
                        processingInAttributeObject.targetObjectInAttribute = targetObjectInAttribute;
                        [processingInAttributeObjects addObject:processingInAttributeObject];

                    }

                    while (processingInAttributeObjects.count > 0) {
                        BZProcessingInAttributeModel *processingInAttributeObject = [processingInAttributeObjects lastObject];
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

                        VVRuntime *runtime = [self runtimeWithClazz:processingInAttributeObject.targetObjectInAttribute.class db:db error:error];
                        if ([self hadError:db error:error]) {
                            return NO;
                        }
                        if (runtime.isRelationshipClazz) {
                            processingInAttributeObject.targetObjectInAttribute.VVRuntime = runtime;
                            enumerator = [processingInAttributeObject.targetObjectInAttribute.VVRuntime objectEnumeratorWithObject:processingInAttributeObject.targetObjectInAttribute];
                            keys = [processingInAttributeObject.targetObjectInAttribute.VVRuntime keysWithObject:processingInAttributeObject.targetObjectInAttribute];
                        }
                        for (NSObject *attributeObjectInEnumerator in enumerator) {
                            Class attributeClazzInEnumerator = [attributeObjectInEnumerator class];
                            VVRuntime *attributeRuntimeInEnumerator = [self runtimeWithClazz:attributeClazzInEnumerator db:db error:error];
                            if ([self hadError:db error:error]) {
                                return NO;
                            }
                            if (attributeRuntimeInEnumerator) {
                                if (attributeRuntimeInEnumerator.isRelationshipClazz) {
                                    attributeObjectInEnumerator.VVRuntime = attributeRuntimeInEnumerator;
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
                                VVRelationshipModel *relationshipObject = [[VVRelationshipModel alloc] init];
                                relationshipObject.fromClassName = targetObject.VVRuntime.clazzName;
                                relationshipObject.fromTableName = targetObject.VVRuntime.tableName;
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
                                    relationshipObject.attributeToObject.VVRuntime = attributeRuntimeInEnumerator;
                                }
                                [relationshipObjects addObject:relationshipObject];
                                [allRelationshipObjects addObject:relationshipObject];
                                attributeSequence++;
                            }
                        }
                        for (VVRelationshipModel *relationshipObject in relationshipObjects) {
                            if (relationshipObject.attributeToObject.VVRuntime.isArrayClazz) {
                                BZProcessingInAttributeModel *processingInAttributeObject = [[BZProcessingInAttributeModel alloc] init];
                                processingInAttributeObject.parentRelationship = relationshipObject;
                                processingInAttributeObject.targetObjectInAttribute = relationshipObject.attributeToObject;
                                [processingInAttributeObjects addObject:processingInAttributeObject];

                            } else if (relationshipObject.attributeToObject.VVRuntime.isObjectClazz) {
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
    VVRuntime *relationshipRuntime = [self runtimeWithClazz:[VVRelationshipModel class] db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    for (BZProcessingModel *processingObject in processingObjects) {
        for (VVRelationshipModel *relationshipObject in processingObject.relationshipObjects) {
            relationshipObject.VVRuntime = relationshipRuntime;
            relationshipObject.fromRowid = relationshipObject.attributeFromObject.rowid;
            if (relationshipObject.attributeToObject) {
                if (relationshipObject.toTableName) {
                    relationshipObject.toRowid = relationshipObject.attributeToObject.rowid;
                }
            }
        }
    }
    for (BZProcessingModel *processingObject in processingObjects) {
        for (VVRelationshipModel *relationshipObject in processingObject.relationshipObjects) {
            [self deleteRelationshipObjectsWithRelationshipObject:relationshipObject db:db];
            if ([self hadError:db error:error]) {
                return NO;
            }
        }
        NSMutableArray *relationshipObjects = [self relationshipObjectsWithObject:processingObject.targetObject attribute:processingObject.attribute relationshipRuntime:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        if (!processingObject.attribute.weakReferenceAttribute) {
            for (VVRelationshipModel *relationshipObject in relationshipObjects) {
                if (relationshipObject.toTableName) {
                    Class targetClazz = NSClassFromString(relationshipObject.toClassName);
                    VVRuntime *targetRuntime = [self runtimeWithClazz:targetClazz db:db error:error];
                    if ([self hadError:db error:error]) {
                        return NO;
                    }
                    if (targetRuntime.isObjectClazz) {
                        NSObject *object = [targetRuntime object];
                        object.VVRuntime = targetRuntime;
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
        [self deleteRelationshipObjectsWithObject:processingObject.targetObject attribute:processingObject.attribute relationshipRuntime:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        [self insertRelationshipObjectsWithRelationshipObjects:processingObject.relationshipObjects db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    for (NSObject *targetObject in allValues) {
        if (targetObject.VVRuntime.modelDidSave) {
            if ([targetObject respondsToSelector:@selector(VVModelDidSave)]) {
                [targetObject performSelector:@selector(VVModelDidSave) withObject:nil];
            }
        }
        if (!self.disableNotifications) {
            if (targetObject.VVRuntime.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeSaved];
            }
        }
    }

    for (NSObject *targetObject in objects) {
        if (!self.disableNotifications) {
            if (targetObject.VVRuntime.notification && !targetObject.VVRuntime.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeSaved];
            }
        }
    }

    return YES;
}


#pragma mark delete methods

- (BOOL)deleteObjects:(Class)clazz condition:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (![self updateConditionRuntime:condition db:db error:error]) {
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
    if (![self updateRuntimes:objects db:db error:error]) {
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
            if (targetObject.VVRuntime.hasRelationshipAttributes) {
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
            for (VVRuntimeProperty *attribute in targetObject.VVRuntime.relationshipAttributes) {
                if (!attribute.weakReferenceAttribute) {
                    NSObject *tagetObjectInAttribute = [targetObject valueForKey:attribute.name];
                    if (tagetObjectInAttribute) {
                        NSMutableArray *tagetObjectsInAttribute = [NSMutableArray array];
                        [tagetObjectsInAttribute addObject:tagetObjectInAttribute];

                        while (tagetObjectsInAttribute.count > 0) {
                            NSObject *tagetObjectInAttribute = [tagetObjectsInAttribute lastObject];
                            [tagetObjectsInAttribute removeLastObject];
                            [self updateRuntime:tagetObjectInAttribute db:db error:error];
                            if ([self hadError:db error:error]) {
                                return NO;
                            }
                            if (tagetObjectInAttribute.VVRuntime.isRelationshipClazz) {
                                NSEnumerator *enumerator = [tagetObjectInAttribute.VVRuntime objectEnumeratorWithObject:tagetObjectInAttribute];
                                for (NSObject *tagetObjectInEnumeratorInAttribute in enumerator) {
                                    VVRuntime *runtime = [self runtimeWithClazz:[tagetObjectInEnumeratorInAttribute class] db:db error:error];
                                    if (runtime.isObjectClazz) {
                                        tagetObjectInEnumeratorInAttribute.VVRuntime = runtime;
                                        [targetObjects addObject:tagetObjectInEnumeratorInAttribute];
                                    } else if (runtime.isArrayClazz) {
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
    VVRuntime *relationshipRuntime = [self runtimeWithClazz:[VVRelationshipModel class] db:db error:error];
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
        [self deleteRelationshipObjectsWithFromObject:targetObject relationshipRuntime:relationshipRuntime db:db];
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
        for (VVRelationshipModel *relationshipObject in relationshipObjects) {
            Class targetClazz = NSClassFromString(relationshipObject.fromClassName);
            if (targetClazz) {
                VVRuntime *runtime = [self runtimeWithClazz:targetClazz db:db error:error];
                if ([self hadError:db error:error]) {
                    return NO;
                }
                if (runtime.isObjectClazz && runtime.cascadeNotification) {
                    NSObject *referencingObject = [runtime object];
                    referencingObject.VVRuntime = runtime;
                    referencingObject.rowid = relationshipObject.fromRowid;
                    [referencingObjects setValue:referencingObject forKey:referencingObject.VVHashForSave];
                }
            }
        }
        [self deleteRelationshipObjectsWithToObject:targetObject relationshipRuntime:relationshipRuntime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    // delete events and notifications
    for (NSObject *targetObject in allValues) {
        if (targetObject.VVRuntime.modelDidDelete) {
            if ([targetObject respondsToSelector:@selector(VVModelDidDelete)]) {
                [targetObject performSelector:@selector(VVModelDidDelete) withObject:nil];
            }
        }
        if (!self.disableNotifications) {
            if (targetObject.VVRuntime.cascadeNotification) {
                VVNotificationCenter *center = [VVNotificationCenter sharedInstance];
                [center postVVNotification:targetObject notificationType:VVDBNotificationTypeDeleted];
            }
        }
    }

    // delete cascade notifications
    for (NSObject *targetObject in objects) {
        if (!self.disableNotifications) {
            if (targetObject.VVRuntime.notification && !targetObject.VVRuntime.cascadeNotification) {
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

- (BOOL)updateConditionRuntime:(VVConditionModel *)condition db:(FMDatabase *)db error:(NSError **)error {
    if (condition.reference.from) {
        if (![self updateRuntime:condition.reference.from db:db error:error]) {
            return NO;
        }
    }
    if (condition.reference.to) {
        if (![self updateRuntime:condition.reference.to db:db error:error]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateRuntimes:(NSArray *)objects db:(FMDatabase *)db error:(NSError **)error {
    for (NSObject *object in objects) {
        if (![self updateRuntime:object db:db error:error]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)updateRuntime:(NSObject *)object db:(FMDatabase *)db error:(NSError **)error {
    if (object.VVRuntime) {
        return YES;
    }
    VVRuntime *runtime = [self runtimeWithClazz:[object class] db:db error:error];
    if (!runtime) {
        return NO;
    }
    object.VVRuntime = runtime;
    return YES;
}


- (VVRuntime *)runtimeWithClazz:(Class)clazz db:(FMDatabase *)db error:(NSError **)error {
    VVRuntime *runtime = [self runtime:clazz];
    if (!runtime) {
        return nil;
    }
    if (runtime.isObjectClazz) {
        [self registerRuntime:runtime db:db error:error];
        if ([self hadError:db error:nil]) {
            return nil;
        }
    }
    return runtime;
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


- (VVRuntime *)runtime:(Class)clazz {
    if (clazz == NULL) {
        return nil;
    }

    Class targetClazz = NULL;
    VVClazz *osclazz = [VVClazz vvclazzWithClazz:clazz];
    if (osclazz.isObjectClazz) {
        targetClazz = clazz;
    } else {
        targetClazz = osclazz.superClazz;
    }

    VVRuntime *runtime = self.registedRuntimes[NSStringFromClass(targetClazz)];
    if (!runtime) {
        runtime = [[VVRuntime alloc] initWithClazz:targetClazz osclazz:osclazz nameBuilder:self.nameBuilder];
        self.registedRuntimes[NSStringFromClass(targetClazz)] = runtime;
    }
    return runtime;

}

- (void)setRegistedRuntimeFlag:(VVRuntime *)runtime {
    self.registedClazzes[runtime.clazzName] = @(YES);
}

- (void)setUnRegistedRuntimeFlag:(VVRuntime *)runtime {
    [self.registedClazzes removeObjectForKey:runtime.clazzName];
}

- (void)setUnRegistedAllRuntimeFlag {
    for (NSString *key in self.registedClazzes.allKeys) {
        [self.registedClazzes removeObjectForKey:key];
    }
}

- (BOOL)registerRuntime:(VVRuntime *)runtime db:(FMDatabase *)db error:(NSError **)error {
    NSNumber *registed = self.registedClazzes[runtime.clazzName];
    if (registed) {
        return YES;
    }

    if (runtime.isObjectClazz) {
        [self createTable:runtime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        if (runtime.clazz == [VVRelationshipModel class]) {
            return YES;
        }
        if (runtime.clazz == [VVRuntime class]) {
            return YES;
        }
        if (runtime.clazz == [VVRuntimeProperty class]) {
            return YES;
        }
        if (![self updateRuntime:runtime db:db error:error]) {
            return NO;
        }
        [self updateRowid:runtime db:db];
        if ([self hadError:db error:error]) {
            return NO;
        }
        [self saveObjects:@[runtime] db:db error:error];
        if ([self hadError:db error:error]) {
            return NO;
        }
    }

    self.registedClazzes[runtime.clazzName] = @YES;
    return YES;
}


- (BOOL)unRegisterRuntime:(VVRuntime *)runtime db:(FMDatabase *)db error:(NSError **)error {
    NSNumber *registed = self.registedClazzes[runtime.clazzName];
    if (!registed.boolValue) {
        return YES;
    }
    [self deleteObjects:runtime.clazz condition:nil db:db error:error];
    if ([self hadError:db error:error]) {
        return NO;
    }
    [self dropTable:runtime db:db];
    if ([self hadError:db error:error]) {
        return NO;
    }
    return YES;
}

@end
