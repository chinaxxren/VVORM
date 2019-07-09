//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVPropertyType.h"


@interface VVPropertyType () {
    NSString *_attributes;
}
@end

@implementation VVPropertyType

- (instancetype)initWithAttributes:(NSString *)attributes {
    self = [super init];
    if (self) {
        _attributes = attributes;
        _isReadonly = NO;
        _isCopy = NO;
        _isRetain = NO;
        _isNonatomic = NO;
        _isDynamic = NO;
        _isWeakReference = NO;
        _isEligibleForGC = NO;
        _isCustomGetter = NO;
        _isCustomSetter = NO;

        _custumGetterName = @"";
        _custumSetterName = @"";

        NSArray *attributeList = [attributes componentsSeparatedByString:@","];
        for (NSString *attribute in attributeList) {
            NSString *code = [attribute substringToIndex:1];
            if ([@"R" isEqualToString:code]) {
                _isReadonly = YES;
            } else if ([@"C" isEqualToString:code]) {
                _isCopy = YES;
            } else if ([@"&" isEqualToString:code]) {
                _isRetain = YES;
            } else if ([@"N" isEqualToString:code]) {
                _isNonatomic = YES;
            } else if ([@"D" isEqualToString:code]) {
                _isDynamic = YES;
            } else if ([@"W" isEqualToString:code]) {
                _isWeakReference = YES;
            } else if ([@"P" isEqualToString:code]) {
                _isEligibleForGC = YES;
            }
            if (attribute != [attributeList firstObject] && attribute == [attributeList lastObject]) {
                if ([@"G" isEqualToString:code]) {
                    _isCustomGetter = YES;
                    _custumGetterName = [attribute substringFromIndex:1];
                } else if ([@"S" isEqualToString:code]) {
                    _isCustomSetter = YES;
                    _custumSetterName = [attribute substringFromIndex:1];
                }
            }
        }
    }

    return self;
}


@end
