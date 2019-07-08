//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVRuntime;

@interface NSObject (VVTabel)

@property(nonatomic, strong) NSNumber *rowid;
@property(nonatomic, strong) VVRuntime *VVRuntime;
@property(nonatomic, readonly) NSString *VVHashForSave;
@property(nonatomic, readonly) NSString *VVHashForFetch;

- (BOOL)isEqualToVVObject:(NSObject *)object;

@end