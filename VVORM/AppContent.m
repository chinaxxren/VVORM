//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "AppContent.h"

#import "VVORM.h"
#import "VVORMManager.h"


@implementation AppContent

+ (VVORM *)current {
    VVORM *dataBase = [VVORMManager getORM:@"login"];
    return dataBase;
}

+ (VVORM *)global {
    VVORM *dataBase = [VVORMManager getORM:@"global"];
    return dataBase;
}

@end
