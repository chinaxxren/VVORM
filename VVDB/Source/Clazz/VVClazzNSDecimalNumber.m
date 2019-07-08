//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSDecimalNumber.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@implementation VVClazzNSDecimalNumber

- (Class)superClazz {
    return [NSDecimalNumber class];
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

- (NSArray *)storeValuesWithValue:(NSDecimalNumber *)value attribute:(VVDBRuntimeProperty *)attribute {
    if (value) {
        return @[value];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSNumber *value = [resultSet objectForColumn:attribute.columnName];
    if ([[value class] isSubclassOfClass:[NSNumber class]]) {
        NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithDecimal:[@([value doubleValue]) decimalValue]];
        return decimalValue;
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_REAL;
}

@end