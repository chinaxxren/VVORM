//
//  ViewController.m
//  VVDB
//
//  Created by Tank on 2019/7/3.
//  Copyright © 2019 Tank. All rights reserved.
//


#import "ViewController.h"

#import <sys/time.h>

#import "User.h"
#import "AppContent.h"
#import "VVORM.h"
#import "Download.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    VVORM *orm = [AppContent current];
    [orm registerClass:[User class]];

//    [orm registerClass:[Download class]];
//    Download *download = [Download new];
//    download.did = [NSUUID UUID].UUIDString;
//    download.name = @"dwonload~222";
//    download.size = 121;
//    [orm saveObject:download];

//    [self testGlobal];
    [self testUser];
}

uint64_t vv_getCurrentTime() {
    struct timeval te;
    gettimeofday(&te, NULL);
    uint64_t microseconds = (uint64_t) (te.tv_sec * 1000 * 1000LL + te.tv_usec);
    return microseconds;
}

- (void)testUser {
    VVORM *orm = [AppContent current];

    uint64_t begin = vv_getCurrentTime();

//    NSMutableArray *users = [NSMutableArray array];

    for (int i = 0; i < 1; i++) {
        User *user = [User new];
//        user.uid = [NSUUID UUID].UUIDString;
        user.uid = [NSString stringWithFormat:@"uid->%i", i];
        user.name = [NSString stringWithFormat:@"user>>%i", i];
        user.age = 171;

        Download *download = [Download new];
//        download.did = [NSUUID UUID].UUIDString;
        download.did = [NSString stringWithFormat:@"did->%i", i];
        download.name = [NSString stringWithFormat:@"download->%i", i];
        download.size = 121;

        user.download = download;
//        [users addObject:user];
        [orm saveObject:user];
    }

//    [orm saveObjects:users];

    NSLog(@"%lld", vv_getCurrentTime() - begin);

//    NSMutableArray *downloads = [orm fetchObjects:[Download class] condition:nil];
//    NSLog(@"%@", downloads);

    NSNumber *count = [orm count:[User class] condition:nil];
    NSLog(@"count->%@", count);

    NSMutableArray *users = [orm findObjects:[User class] condition:nil];
    User *user = [users lastObject];
    NSLog(@"name->%@", user.name);
}

- (void)testGlobal {
    Download *download = [Download new];
    download.name = @"dwonload-1";
    download.size = 1024;

    VVORM *orm = [AppContent global];
    [orm saveObject:download];

    NSNumber *count = [orm count:[Download class] condition:nil];
    NSLog(@"count->%@", count);

    NSMutableArray *downloads = [orm findObjects:[Download class] condition:nil];
    download = [downloads firstObject];
    NSLog(@"name->%@", download.name);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    [self testUser];

    VVORM *orm = [AppContent current];

//    NSMutableArray *downloads = [orm fetchObjects:[Download class] condition:nil];
//    NSLog(@"%@", downloads);

    uint64_t begin = vv_getCurrentTime();
    NSMutableArray *users = [orm findObjects:[User class] condition:nil];
    NSLog(@"%lld", vv_getCurrentTime() - begin);
    User *user = [users firstObject];
    NSLog(@"name->%@", user.name);
}

@end
