//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBNameBuilder.h"
#import "VVModelInterface.h"


@implementation VVDBNameBuilder

- (NSString *)tableName:(Class)clazz {
    NSString *tableName = nil;
    if ([clazz conformsToProtocol:@protocol(VVModelInterface)]) {
        if ([clazz respondsToSelector:@selector(VVTableName)]) {
            tableName = (NSString *) [clazz performSelector:@selector(VVTableName) withObject:nil];
        }
    }

    if (!tableName || [tableName isEqualToString:@""]) {
        tableName = NSStringFromClass(clazz);
        NSString *ignorePrefixName = self.ignorePrefixName;
        if (ignorePrefixName) {
            if ([tableName hasPrefix:ignorePrefixName]) {
                tableName = [tableName substringFromIndex:ignorePrefixName.length];
            }
        }
        NSString *ignoreSuffixName = self.ignoreSuffixName;
        if (ignoreSuffixName) {
            if ([tableName hasSuffix:ignoreSuffixName]) {
                tableName = [tableName substringToIndex:tableName.length - ignoreSuffixName.length];
            }
        }
    }

    return tableName;
}

- (NSString *)columnName:(NSString *)name clazz:(Class)clazz {
    NSString *columnName = name;
    if ([clazz conformsToProtocol:@protocol(VVModelInterface)]) {
        if ([clazz respondsToSelector:@selector(VVTableName)]) {
            columnName = (NSString *) [clazz performSelector:@selector(VVColumnName:) withObject:name];
        }
    }
    return columnName;
}

@end