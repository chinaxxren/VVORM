//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVModelInterface.h"

@class Download;


@interface User : NSObject <VVModelInterface>

@property(nonatomic, copy) NSString<VVIdenticalAttribute> *uid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, strong) Download *download;

@end