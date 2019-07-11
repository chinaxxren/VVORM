//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVPropertyInfo;


@interface VVMigrationRuntimeProperty : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) VVPropertyInfo *previousAttribute;
@property(nonatomic, strong) VVPropertyInfo *latestAttbiute;
@property(nonatomic, assign) BOOL added;
@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, assign) BOOL typeChanged;
@property(nonatomic, assign) BOOL columnNameChanged;

@end
