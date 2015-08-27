//
// Created by lizhihui on 14/12/2.
// Copyright (c) 2014 lizhihui. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import "FileManager.h"
#import "GBSCommonTools.h"
#include "DBField.h"

static NSString * const DefaultDBName = @"DB.sqlite";

@interface DatabaseManager ()
{
    NSString *_databasePath;
    FMDatabaseQueue *_databaseQueue;
}
- (void)inDatabase:(void (^)(FMDatabase *db))block;
@property (nonatomic,strong,readonly) FMDatabaseQueue *databaseQueue;
@end

@implementation DatabaseManager

+ (instancetype)defaultManager {
    static DatabaseManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *databasePath = [[FileManager pathForDocumentsDirectory] stringByAppendingPathComponent:DefaultDBName];
        _sharedManager = [[DatabaseManager alloc] initWithPath:databasePath];
    });
    return _sharedManager;
}

- (FMDatabaseQueue *)databaseQueue{
    _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:_databasePath];
    return _databaseQueue;
}

- (instancetype)initWithPath:(NSString *)aPath
{
    self = [super init];
    if (self) {
        _databasePath = aPath;
        NSParameterAssert(_databasePath);
    }
    return self;
}

- (void)inDatabase:(void (^)(FMDatabase *db))block{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db setDateFormat:[GBSCommonTools dateFormatterFromTemplate:@"yyyy-MM-dd HH:mm:ss SSSS"]];
        block(db);
        [db close];
    }];
}

- (FMResultSet *)selectFromTable:(NSString *)tableName fields:(NSArray *)fields conditions:(NSString *)conditions{
    __block FMResultSet * resultSet= nil;
    [self inDatabase:^(FMDatabase *db) {
        // generate a sql with components
        // after first component is `select field1, field2, field3,... from tablename where conditions` conditions meaning a validate sql conditions
        NSString *field = [fields componentsJoinedByString:@", "];
        NSMutableString *sql = [NSMutableString stringWithFormat:@"select %@ from %@ where %@",field,tableName,conditions];
        resultSet = [db executeQuery:sql];
    }];
    return resultSet;
}

- (BOOL)deleteFromTableWithName:(NSString *)tableName conditions:(NSString *)conditions{
    __block BOOL isSuccessful =  NO;
    [self inDatabase:^(FMDatabase *db) {
        // generate a sql with components
        // after first component is `delete from tablename where conditions` conditions meaning a validate sql conditions
        NSMutableString *sql = [NSMutableString stringWithFormat:@"delete from %@ where %@",tableName,conditions];
        isSuccessful = [db executeUpdate:sql];
    }];
    
    return isSuccessful;
}

- (BOOL)insertIntoTableWithName:(NSString *)tableName fields:(NSDictionary *)fields{
    __block BOOL isSuccessful = NO;
    [self inDatabase:^(FMDatabase *db) {
        // generate a sql with components
        // after first component is `insert into tablename `
        NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@",tableName];
        
        // after second component is `insert into tablename (field1,filed2,filed3,....)`
        NSArray *keys = [fields allKeys];
        for (NSString *key in keys) {
            if (key == [keys firstObject]) [sql appendString:@"("];
            [sql appendFormat:@"%@",key];
            if (key == [keys lastObject]) [sql appendString:@")"]; else [sql appendString:@", "];
        }
        
        // after third component is `insert into tablename (field1,filed2,filed3,....) values `
        [sql appendString:@" values "];
        
        // after fourthly component is `insert into tablename values (field1,filed2,filed3,...) values (:field1,:field2,:field3,...)`
        for (NSString *key in keys) {
            if (key == [keys firstObject]) [sql appendString:@"("];
            [sql appendFormat:@":%@",key];
            if (key == [keys lastObject]) [sql appendString:@")"]; else [sql appendString:@", "];
        }
        // excute the finally sql
        isSuccessful = [db executeUpdate:sql withParameterDictionary:fields];
    }];
    return isSuccessful;
}

- (BOOL)createTableWithName:(NSString *)tableName fields:(NSArray *)fields{
    __block BOOL isSuccessful = NO;
    [self inDatabase:^(FMDatabase *db) {
        // if the table is exist we sample return YES
        if ([db tableExists:tableName]) { isSuccessful = YES; return; }
        
        // generate a sql with components
        // after first component is `create table tablename`
        NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@",tableName];
        
        // after second component is `create table tablename (field1 fieldType default defaultValue,field2 fieldType default defaultValue,field3 fieldType default defaultValue,...)`
        for (DBField *field in fields) {
            if (field == [fields firstObject]) [sql appendString:@"( "];
            NSString *sqlField = [field sqlField];
            [sql appendString:sqlField];
            if (field == [fields lastObject]) [sql appendString:@" )"]; else [sql appendString:@","];
        }
        
        // excute the finally sql
        isSuccessful = [db executeUpdate:sql];
    }];
    return isSuccessful;
}

@end