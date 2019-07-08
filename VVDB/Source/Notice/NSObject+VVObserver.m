//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "NSObject+VVDBObserver.h"

#import <objc/runtime.h>

@implementation NSObject (VVDBObserver)

- (NSMutableArray *)VVDBbservers {
    return objc_getAssociatedObject(self, @selector(setVVDBbservers:));
}

- (void)setVVDBbservers:(NSArray *)VVDBbservers {
    objc_setAssociatedObject(self, _cmd, VVDBbservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end