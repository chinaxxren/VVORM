//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "AppContext.h"

#import "VVDataBase.h"
#import "VVDataBaseManager.h"


@implementation AppContext

+ (VVDataBase *)database {
    VVDataBase *dataBase = [VVDataBaseManager getDataBase:@"test"];
    return dataBase;
}

@end