//
//  DBManager.m
//  DefinePhoto
//
//  Created by addmin on 17/6/8.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager
+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists studentsDetail (regno integer primary key, name text, department text, year text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK) {
                
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
       department:(NSString*)department year:(NSString*)year {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (regno,name, department, year) values (\"%ld\",\"%@\", \"%@\", \"%@\")",[registerNumber integerValue],
                               name, department, year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            return YES;
        } else {
            
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSArray*) findByRegisterNumber:(NSString*)registerNumber {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        NSString *querySQL = [NSString stringWithFormat: @"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database,  query_stmt, -1, & statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                return resultArray;
            } else {
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
//检查文件是否存在
-(BOOL)checkfileManagerExist{
    
    BOOL IsExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Get documents directory
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    IsExist =  [fileManager fileExistsAtPath:@""];
    if (IsExist) {
        
        NSLog(@"File NOexists");
    }
    //比较两个文件
    if ([fileManager contentsEqualAtPath:@"FilePath1" andPath:@" FilePath2"]) {
        NSLog(@"Same content");
    }
   // 检查是否可写、可读、可执行文件
    
    if ([fileManager isWritableFileAtPath:@"FilePath"]) {
        NSLog(@"isWritable可写");
    }
    if ([fileManager isReadableFileAtPath:@"FilePath"]) {
        NSLog(@"isReadable可读");
    }
    if ( [fileManager isExecutableFileAtPath:@"FilePath"]){
        NSLog(@"is Executable可执行");
    }
    //移动文件
    if([fileManager moveItemAtPath:@"FilePath1"
                            toPath:@"FilePath2" error:NULL]){
        NSLog(@"Moved successfully");
    }
    //复制文件
    if ([fileManager copyItemAtPath:@"FilePath1"
                             toPath:@"FilePath2"  error:NULL]) {
        NSLog(@"Copied successfully");
    }
    //删除文件
    if ([fileManager removeItemAtPath:@"FilePath" error:NULL]) {
    NSLog(@"Removed successfully");
    }
    //读取文件
    NSData *data = [fileManager contentsAtPath:@"Path"];
    //写入文件
    [fileManager createFileAtPath:@"" contents:data attributes:nil];
    
    return IsExist;
}
@end
