//
// Created by Tank on 2019-07-08.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVMigrationTable;


@interface VVMigrationQueryBuilder : NSObject

+ (NSString *)createTempTableStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)createTemporaryUniqueIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)createUniqueIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)selectInsertStatementWithToMigrationTable:(VVMigrationTable *)toMigrationTable fromMigrationTable:(VVMigrationTable *)fromMigrationTable;

+ (NSString *)deleteFromStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)dropTableStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)dropTempIndexStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

+ (NSString *)alterTableRenameStatementWithMigrationTable:(VVMigrationTable *)migrationTable;

@end