# VVORM

1. 支持多线程和后台数据库操作
1. 支持文本搜索、FTS3和FTS4
1. 字段处理有自定义主键、忽略标识字段、属性值更新次数、只更新空值字段、
1. 忽略父类属性、支持保存和更新优先级
1. 自动检测生成表结构、和表结构升级
1. 支持一个APP中多数据库操作
1. 支持ActiveRecord
1. 自动模型和表的映射

```

- (void)viewDidLoad {
    [super viewDidLoad];

    VVORM *orm = [AppContent current];
    [orm registerClass:[User class]];

    [orm registerClass:[Download class]];
    Download *download = [Download new];
    download.did = [NSUUID UUID].UUIDString;
    download.name = @"dwonload~222";
    download.size = 121;
    [orm saveObject:download];
    
    [orm deleteObjects:[Download class] condition:nil];
    
//    [self testGlobal];
//    [self testUser];
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
        user.city = [NSString stringWithFormat:@"city->%i", i];
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

    NSNumber *count = [orm count:[User class] condition:[VVCondition where:@"age = ? " parameters:@[@171]]];
    NSLog(@"count->%@", count);

    NSMutableArray *users = [orm findObjects:[User class] condition:nil];
    User *user = [users lastObject];
    NSLog(@"name->%@", user.city);
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

```

# 使用
pod 'VVORM'

