//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBClazzNSMutableString.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVDBClazzNSMutableString

- (Class)superClazz {
    return [NSMutableString class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (BOOL)isPrimaryClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSMutableString *)value attribute:(VVDBRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSString *string = [resultSet stringForColumn:attribute.columnName];
    if (string) {
        return [NSMutableString stringWithString:string];
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_TEXT;
}

@end
