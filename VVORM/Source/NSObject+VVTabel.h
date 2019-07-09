//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORMClass;

@interface NSObject (VVTabel)

@property(nonatomic, strong) NSNumber *rowid;
@property(nonatomic, strong) VVORMClass *VVRuntime;
@property(nonatomic, readonly) NSString *VVHashForSave;
@property(nonatomic, readonly) NSString *VVHashForFetch;

- (BOOL)isEqualToVVObject:(NSObject *)object;

@end