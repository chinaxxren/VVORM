//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVDBRuntimeProperty;


@interface VVDBMigrationRuntimeProperty : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) VVDBRuntimeProperty *previousAttribute;
@property(nonatomic, strong) VVDBRuntimeProperty *latestAttbiute;
@property(nonatomic, assign) BOOL added;
@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, assign) BOOL typeChanged;
@property(nonatomic, assign) BOOL columnNameChanged;

@end