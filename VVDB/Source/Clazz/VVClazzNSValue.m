//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVClazzNSValue.h"

#import <FMDB/FMResultSet.h>

#import "VVDBConst.h"
#import "VVDBRuntimeProperty.h"

@interface NSValueConverter ()

@property(nonatomic, strong) NSString *objCType;
@property(nonatomic, strong) NSData *data;

@end

@implementation NSValueConverter

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _objCType = [aDecoder decodeObjectForKey:@"objCType"];
        _data = [aDecoder decodeObjectForKey:@"data"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_objCType forKey:@"objCType"];
    [aCoder encodeObject:_data forKey:@"data"];
}

+ (NSData *)convertedDataWithValue:(NSValue *)value {
    NSValueConverter *holder = [[self alloc] initWithValue:value];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:holder];
    return data;
}

+ (NSValue *)valueWithConvertedData:(NSData *)convertedData {
    NSValueConverter *holder = [NSKeyedUnarchiver unarchiveObjectWithData:convertedData];
    const char *objCType = [holder.objCType cStringUsingEncoding:NSUTF8StringEncoding];
    return [NSValue valueWithBytes:[holder.data bytes] objCType:objCType];
}

- (instancetype)initWithValue:(NSValue *)value {
    if (self = [super init]) {
        _objCType = [self _objCTypeWithValue:value];
        _data = [self _dataWithValue:value];
    }
    return self;
}

- (NSData *)_dataWithValue:(NSValue *)value {
    NSUInteger size;
    const char *encoding = [value objCType];
    NSGetSizeAndAlignment(encoding, &size, NULL);
    void *ptr = malloc(size);
    [value getValue:ptr];
    NSData *data = [NSData dataWithBytes:ptr length:size];
    free(ptr);
    return data;
}

- (NSString *)_objCTypeWithValue:(NSValue *)value {
    const char *objCType = [value objCType];
    return [NSString stringWithCString:objCType encoding:NSUTF8StringEncoding];
}

@end

@implementation VVClazzNSValue

- (Class)superClazz {
    return [NSValue class];
}

- (NSString *)attributeType {
    return NSStringFromClass([self superClazz]);
}

- (BOOL)isSimpleValueClazz {
    return YES;
}

- (NSArray *)storeValuesWithValue:(NSValue *)value attribute:(VVDBRuntimeProperty *)attribute {
    if (value) {
        return @[[NSValueConverter convertedDataWithValue:value]];
    }
    return @[[NSNull null]];
}

- (id)valueWithResultSet:(FMResultSet *)resultSet attribute:(VVDBRuntimeProperty *)attribute {
    NSData *value = [resultSet objectForColumn:attribute.columnName];
    if (value && [[value class] isSubclassOfClass:[NSData class]]) {
        return [NSValueConverter valueWithConvertedData:value];
    }
    return nil;
}

- (NSString *)sqliteDataTypeName {
    return SQLITE_DATA_TYPE_BLOB;
}

@end
