//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORM;


@interface VVORMManager : NSObject

+ (instancetype)share;

- (VVORM *)getORM:(NSString *)name;

+ (VVORM *)getORM:(NSString *)name;

@end
