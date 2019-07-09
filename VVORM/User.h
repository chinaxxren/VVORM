//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Download;


@interface User : NSObject

@property(nonatomic, strong) Download *download;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;


@end