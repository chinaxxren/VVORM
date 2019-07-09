//
// Created by Tank on 2019-07-03.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "NSObject+VVTabel.h"

#import <objc/runtime.h>

#import "VVORMClass.h"

@implementation NSObject (VVTabel)

- (NSNumber *)rowid {
    return objc_getAssociatedObject(self, @selector(setRowid:));
}

- (void)setRowid:(NSNumber *)rowid {
    objc_setAssociatedObject(self, _cmd, rowid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VVORMClass *)VVRuntime {
    return objc_getAssociatedObject(self, @selector(setVVRuntime:));
}

- (void)setVVRuntime:(VVORMClass *)runtime {
    objc_setAssociatedObject(self, _cmd, runtime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)VVHashForSave {
    NSNumber *number = @([self hash]);
    NSString *hash = [NSString stringWithFormat:@"%@", [number stringValue]];
    return hash;
}

- (NSString *)VVHashForFetch {
    NSString *hash = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), [self.rowid stringValue]];
    return hash;
}

- (BOOL)isEqualToVVObject:(NSObject *)object {
    if (self == object) {
        return YES;
    } else if ([self class] == [object class]) {
        if (self.rowid && object.rowid) {
            if ([self.rowid isEqualToNumber:object.rowid]) {
                return YES;
            }
        }
    }
    return NO;
}

@end