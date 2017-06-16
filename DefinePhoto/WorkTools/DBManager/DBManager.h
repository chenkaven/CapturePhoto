//
//  DBManager.h
//  DefinePhoto
//
//  Created by addmin on 17/6/8.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import <Foundation/Foundation.h>
//选择项目文件，然后选择目标，添加libsqlite3.dylib库到选择框架
#import <sqlite3.h>
@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

-(BOOL)createDB;

-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;

-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;

@end
