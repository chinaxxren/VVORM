//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VVIgnoreSuperClass
@end

@protocol VVFullTextSearch3
@end

@protocol VVFullTextSearch4
@end

@protocol VVInsertPerformance
@end

@protocol VVUpdatePerformance
@end

@protocol VVIdenticalAttribute
@end

@protocol VVIgnoreAttribute
@end

@protocol VVNotUpdateIfValueIsNullAttribute
@end

@protocol VVSerializableAttribute
@end

@protocol VVOnceUpdateAttribute
@end

@protocol VVModelInterface <NSObject>

@optional

+ (NSString *)VVTableName;

+ (NSString *)VVColumnName:(NSString *)attributeName;

+ (BOOL)attributeIsVVIdenticalAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVIgnoreAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVFetchOnRefreshingAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVNotUpdateIfValueIsNullAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVSerializableAttribute:(NSString *)attributeName;

+ (BOOL)attributeIsVVOnceUpdateAttribute:(NSString *)attributeName;

@end

@interface NSObject (VVAttributeProtocol) <VVIgnoreSuperClass,
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

@implementation NSString (VVAttributeProtocol)

@end
