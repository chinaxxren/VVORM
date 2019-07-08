//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

// https://developer.apple.com/library/ios/documentation/cocoa/conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5

@interface VVPropertyType : NSObject

//
- (instancetype)initWithAttributes:(NSString *)attributes;

// Declared property type encodings
@property(nonatomic, assign, readonly) BOOL isReadonly;
@property(nonatomic, assign, readonly) BOOL isCopy;
@property(nonatomic, assign, readonly) BOOL isRetain;
@property(nonatomic, assign, readonly) BOOL isNonatomic;
@property(nonatomic, assign, readonly) BOOL isCustomSetter;
@property(nonatomic, assign, readonly) BOOL isCustomGetter;
@property(nonatomic, assign, readonly) BOOL isDynamic;
@property(nonatomic, assign, readonly) BOOL isWeakReference;
@property(nonatomic, assign, readonly) BOOL isEligibleForGC;
@property(nonatomic, assign, readonly) BOOL isOldStyleSpecifiesType;
@property(nonatomic, strong, readonly) NSString *custumSetterName;
@property(nonatomic, strong, readonly) NSString *custumGetterName;

@end