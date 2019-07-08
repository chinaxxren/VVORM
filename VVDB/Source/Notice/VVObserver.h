//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, VVDBNotificationType) {
    VVDBNotificationTypeSaved,
    VVDBNotificationTypeDeleted
};

@interface VVDBObserver : NSObject

@property(nonatomic, strong) NSObject *object;
@property(nonatomic, strong) NSObject *target;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, assign) VVDBNotificationType notificationType;

- (void)received:(NSNotification *)notification;

@end