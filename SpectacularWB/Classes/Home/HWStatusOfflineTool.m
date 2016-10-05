//
//  HWStatusOfflineTool.m
//  SpectacularWB
//
//  Created by Figo Han on 2016-10-03.
//  Copyright © 2016 Figo Han. All rights reserved.
//

#import "HWStatusOfflineTool.h"
#import "FMDB.h"
@implementation HWStatusOfflineTool
static FMDatabase * db;
+(void)initialize
{
    
    // 1. 创建数据库路径，然后创建数据库
    NSString * path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * appendedPath=[path stringByAppendingPathComponent:@"status.sqlite"];
    
    db=[FMDatabase databaseWithPath:appendedPath];
    
    
    
    //2. 打开数据库
    [db open];
    
    
    //3. 创建表格  bolb : it is stored as it was input
//    [db executeQuery:@"CREATE TABLE IF NOT EXSITS t_status(id integer PRIMARY KEY, status blob NOT NUll, idstr text NOT NUll);"];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"];
    
    
}


+(void)saveStatus:(NSArray *)statuses
{
    for (NSDictionary * status in statuses) {
         NSData * statusData=[NSKeyedArchiver archivedDataWithRootObject:status];
//        [db executeUpdate:@"INSERT INTO t_status(status,idstr) VALUES (%@, %@);",statusData, [status objectForKey:@"idstr"]];
        [db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);", statusData, status[@"idstr"]];
    }
}

+(NSArray*)offineStatusWithDictionary:(NSDictionary *)parameters
{
    
    NSString * sql=nil;
    if ([parameters objectForKey:@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;", [parameters objectForKey:@"since_id"]];
    }
    else if ([parameters objectForKey:@"max_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;", [parameters objectForKey:@"max_id"]];
    } else {
        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }

    FMResultSet * set=[db executeQuery:sql];
    NSMutableArray * statusArray=[NSMutableArray array];
    while (set.next) {
        NSData * statusData=[set objectForColumnName:@"status"];  // return status which has been transfered to NSData
        NSDictionary * status=[NSKeyedUnarchiver unarchiveObjectWithData:statusData];  // transfer to orginal data
        
        [statusArray addObject:status];
    }
    return statusArray;
}
@end

















