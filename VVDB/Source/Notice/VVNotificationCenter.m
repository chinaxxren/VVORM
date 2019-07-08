//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBNotificationCenter.h"

#import "NSObject+VVDB.h"
#import "NSObject+VVDBObserver.h"

@implementation VVDBNotificationCenter

+ (instancetype)sharedInstance {
    @synchronized (self) {
        static id _sharedInstance = nil;
        if (!_sharedInstance) {
            _sharedInstance = [[VVDBNotificationCenter alloc] init];
        }
        return _sharedInstance;
    }
}

- (void)postVVNotification:(NSObject *)object notificationType:(VVDBNotificationType)notificationType {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"object"] = object;
    NSString *name = [self nameWithObject:object notificationType:notificationType];
    NSNotification *notification = [NSNotification notificationWithName:name object:nil userInfo:userInfo];
    [self postNotification:notification];
}

- (void)addVVObserver:(id)target selector:(SEL)selector object:(NSObject *)object notificationType:(VVDBNotificationType)notificationType {
    if (!object) {
        return;
    }
    VVObserver *observer = [[VVObserver alloc] init];
    observer.object = object;
    observer.target = target;
    observer.selector = selector;
    observer.notificationType = notificationType;

    NSString *name = [self nameWithObject:object notificationType:notificationType];
    [self addObserver:observer selector:@selector(received:) name:name object:nil];

    NSObject *targetObject = target;
    @synchronized (targetObject) {
        if (!targetObject.VVDBbservers) {
            targetObject.VVDBbservers = [NSMutableArray array];
        }
        [targetObject.VVDBbservers addObject:observer];
    }
}

- (NSString *)nameWithObject:(NSObject *)object notificationType:(VVDBNotificationType)notificationType {
    NSString *name = [NSString stringWithFormat:@"VVDBNotification_%@_%ld", NSStringFromClass([object class]), (long) notificationType];
    return name;
}

@end
