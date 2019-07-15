//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "FMDatabase+IndexInfo.h"


@implementation FMDatabase (IndexInfo)

- (BOOL)indexExists:(NSString *)indexName {

    indexName = [indexName lowercaseString];

    FMResultSet *rs = [self executeQuery:@"select [sql] from sqlite_master where [type] = 'index' and lower(name) = ?", indexName];

    //if at least one next exists, table exists
    BOOL returnBool = [rs next];

    //close and free object
    [rs close];

    return returnBool;
}

- (NSArray *)columnNamesWithIndexName:(NSString *)indexName {
    NSMutableArray *columnNames = [NSMutableArray array];
    FMResultSet *rs = [self executeQuery:[NSString stringWithFormat:@"PRAGMA index_info(%@)", indexName]];
    while (rs.next) {
        [columnNames addObject:[rs stringForColumn:@"name"]];
    }
    [rs close];

    return [NSArray arrayWithArray:columnNames];
}

@end
