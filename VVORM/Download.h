//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VVIdenticalAttribute;


@interface Download : NSObject

@property(nonatomic, copy) NSString <VVIdenticalAttribute> *did;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger size;

@end