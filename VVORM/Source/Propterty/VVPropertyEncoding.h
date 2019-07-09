//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


// https://developer.apple.com/library/ios/documentation/cocoa/conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1

/*
 属性的类型
 */
@interface VVPropertyEncoding : NSObject

- (instancetype)initWithAttributes:(NSString *)attributes;

@property(nonatomic, strong, readonly) NSString *code;

// Objective-C type encodings
@property(nonatomic, assign, readonly) BOOL isChar;
@property(nonatomic, assign, readonly) BOOL isInt;
@property(nonatomic, assign, readonly) BOOL isShort;
@property(nonatomic, assign, readonly) BOOL isLong;
@property(nonatomic, assign, readonly) BOOL isLongLong;
@property(nonatomic, assign, readonly) BOOL isUnsignedChar;
@property(nonatomic, assign, readonly) BOOL isUnsignedInt;
@property(nonatomic, assign, readonly) BOOL isUnsignedShort;
@property(nonatomic, assign, readonly) BOOL isUnsignedLong;
@property(nonatomic, assign, readonly) BOOL isUnsignedLongLong;
@property(nonatomic, assign, readonly) BOOL isFloat;
@property(nonatomic, assign, readonly) BOOL isDouble;
@property(nonatomic, assign, readonly) BOOL isBool;
@property(nonatomic, assign, readonly) BOOL isVoid;
@property(nonatomic, assign, readonly) BOOL isCharString;
@property(nonatomic, assign, readonly) BOOL isObject;
@property(nonatomic, assign, readonly) BOOL isClass;
@property(nonatomic, assign, readonly) BOOL isMethodSelector;
@property(nonatomic, assign, readonly) BOOL isArray;
@property(nonatomic, assign, readonly) BOOL isStructure;
@property(nonatomic, assign, readonly) BOOL isUnion;
@property(nonatomic, assign, readonly) BOOL isBit;
@property(nonatomic, assign, readonly) BOOL isPointer;
@property(nonatomic, assign, readonly) BOOL isUnknown;

// Objective-C method encodings
@property(nonatomic, assign, readonly) BOOL isConst;
@property(nonatomic, assign, readonly) BOOL isIn;
@property(nonatomic, assign, readonly) BOOL isInOut;
@property(nonatomic, assign, readonly) BOOL isOut;
@property(nonatomic, assign, readonly) BOOL isByCopy;
@property(nonatomic, assign, readonly) BOOL isByRef;
@property(nonatomic, assign, readonly) BOOL isOneway;

@end
