//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORM;


@interface VVORMManager : NSObject

+ (instancetype)share;

- (VVORM *)getDataBase:(NSString *)name;

+ (VVORM *)getDataBase:(NSString *)name;

@end
