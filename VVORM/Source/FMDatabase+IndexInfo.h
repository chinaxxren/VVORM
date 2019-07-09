//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDatabase.h>

@interface FMDatabase (IndexInfo)

- (BOOL)indexExists:(NSString *)indexName;

- (NSArray *)columnNamesWithIndexName:(NSString *)indexName;

@end