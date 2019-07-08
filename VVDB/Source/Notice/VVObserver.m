//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDBObserver.h"

#import "VVDBNotificationCenter.h"
#import "NSObject+VVDB.h"

@implementation VVDBObserver

- (void)dealloc {
    [[VVDBNotificationCenter defaultCenter] removeObserver:self];
}

- (void)received:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSObject *object = [dic valueForKey:@"object"];
    if (object.rowid && self.object.rowid) {
        if ([object.rowid isEqualToNumber:self.object.rowid]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (self.notificationType == VVDBNotificationTypeSaved) {
                [self.target performSelector:self.selector withObject:self.object withObject:object];
            } else if (self.notificationType == VVDBNotificationTypeDeleted) {
                [self.target performSelector:self.selector withObject:object];
            }
#pragma clang diagnostic pop
        }
    }
}

@end
