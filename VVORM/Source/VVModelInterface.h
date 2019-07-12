//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

// 忽略父类的属性
@protocol VVIgnoreSuperClass
@end

// 支持 sqlite FTS3
@protocol VVFullTextSearch3
@end

// 支持 sqlite FTS4
@protocol VVFullTextSearch4
@end

// 优先的插入性能
@protocol VVInsertPerformance
@end

// 优先的更新性能
@protocol VVUpdatePerformance
@end

// 定义数据库主键
@protocol VVIdenticalAttribute
@end

// 忽略当前字段
@protocol VVIgnoreAttribute
@end

// 当新设置的值为空时，不更新属性原有值。
@protocol VVNotUpdateIfValueIsNullAttribute
@end

// 更新属性值只有一次。
@protocol VVOnceUpdateAttribute
@end

@protocol VVSerializableAttribute
@end

@protocol VVModelInterface <NSObject>

@optional

+ (NSString *)VVTableName;

// Change ColumnName
+ (NSString *)VVColumnName:(NSString *)attributeName;

+ (BOOL)attributeIsVVIdenticalAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVIgnoreAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVNotUpdateIfValueIsNullAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVSerializableAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVOnceUpdateAttribute:(NSString *)attributeName;

@end


@interface NSObject (VVProtocol) <VVIgnoreSuperClass,
        VVFullTextSearch3,
        VVFullTextSearch4,
        VVInsertPerformance,
        VVUpdatePerformance,
        VVIdenticalAttribute,
        VVIgnoreAttribute,
        VVNotUpdateIfValueIsNullAttribute,
        VVSerializableAttribute,
        VVOnceUpdateAttribute>
@end

@implementation NSString (VVProtocol)

@end