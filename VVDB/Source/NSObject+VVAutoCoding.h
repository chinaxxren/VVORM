//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 在iOS6中，苹果引入了一个新的协议，是基于NSCoding的，叫做NSSecureCoding。
 NSSecureCoding和NSCoding是一样的，除了在解码时要同时指定key和要解码的对象的类，
 如果要求的类和从文件中解码出的对象的类不匹配，NSCoder会抛出异常，告诉你数据已经被篡改了
 */
@interface NSObject (VVAutoCoding) <NSSecureCoding>

+ (NSDictionary<NSString *, Class> *)codableProperties;

- (void)setWithCoder:(NSCoder *)aDecoder;

@property(nonatomic, readonly) NSDictionary<NSString *, Class> *codableProperties;

@property(nonatomic, readonly) NSDictionary<NSString *, id> *dictionaryRepresentation;

+ (instancetype)objectWithContentsOfFile:(NSString *)path;

- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end

NS_ASSUME_NONNULL_END