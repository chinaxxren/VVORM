//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VVNameBuilder : NSObject

@property(nonatomic, strong) NSString *ignorePrefixName;
@property(nonatomic, strong) NSString *ignoreSuffixName;

- (NSString *)tableName:(Class)clazz;

- (NSString *)columnName:(NSString *)name clazz:(Class)clazz;

@end