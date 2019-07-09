//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORMClass;


@interface VVMigrationRuntime : NSObject

@property(nonatomic, copy) NSString *clazzName;
@property(nonatomic, strong) NSMutableDictionary *attributes;
@property(nonatomic, strong) VVORMClass *previousRuntime;
@property(nonatomic, strong) VVORMClass *latestRuntime;
@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, assign) BOOL changed;
@property(nonatomic, assign) BOOL tableNameChanged;

@end