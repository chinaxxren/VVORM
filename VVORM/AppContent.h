//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVORM;


@interface AppContent : NSObject

+ (VVORM *)current;

+ (VVORM *)global;

@end
