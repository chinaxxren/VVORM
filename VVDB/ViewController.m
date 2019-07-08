//
//  ViewController.m
//  VVDB
//
//  Created by Tank on 2019/7/3.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "User.h"
#import "AppContent.h"
#import "VVDataBase.h"
#import "Download.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testUser];
    [self testGlobal];
}

- (void)testUser {
    User *user = [User new];
    user.name = @"user-1";
    user.age = 18;

    VVDataBase *userDB = [AppContent user];
    [userDB saveObject:user];

    NSNumber *count = [userDB count:[User class] condition:nil];
    NSLog(@"%@", count);

    NSMutableArray *users = [userDB fetchObjects:[User class] condition:nil];
    user = [users firstObject];
    NSLog(@"%@", user.name);
}

- (void)testGlobal {
    Download *download = [Download new];
    download.name = @"dwonload-1";
    download.size = 1024;

    VVDataBase *globalDB = [AppContent global];
    [globalDB saveObject:download];

    NSNumber *count = [globalDB count:[Download class] condition:nil];
    NSLog(@"%@", count);

    NSMutableArray *downloads = [globalDB fetchObjects:[Download class] condition:nil];
    download = [downloads firstObject];
    NSLog(@"%@", download.name);
}


@end
