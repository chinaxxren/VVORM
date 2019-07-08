//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVObserver.h"


@interface VVDBNotificationCenter : NSNotificationCenter

+ (instancetype)sharedInstance;

- (void)postVVNotification:(NSObject *)object notificationType:(VVDBNotificationType)notificationType;

- (void)addVVObserver:(id)target selector:(SEL)selector object:(NSObject *)object notificationType:(VVDBNotificationType)notificationType;

@end