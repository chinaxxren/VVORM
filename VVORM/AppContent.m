//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "AppContent.h"

#import "VVDataBase.h"
#import "VVDataBaseManager.h"


@implementation AppContent

+ (VVDataBase *)user {
    VVDataBase *dataBase = [VVDataBaseManager getDataBase:@"login"];
    return dataBase;
}

+ (VVDataBase *)global {
    VVDataBase *dataBase = [VVDataBaseManager getDataBase:@"global"];
    return dataBase;
}

@end