//
//  KeyChain.h
//  DefinePhoto
//
//  Created by addmin on 17/6/14.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import <Foundation/Foundation.h>
//使复杂对象接受NSCoding(委托)协议
@interface KeyChain : NSObject<NSCoding>
//数据
@property(nonatomic,copy) id   model;
//数据-key
@property(nonatomic,copy)NSString  *modelKey;

@property (nonatomic, copy)NSString     *gender;//性别
@property (nonatomic, copy)NSString     *name;//姓名
@property (nonatomic, copy)NSString     *age;//年龄

+(KeyChain *)shareInstance;
#pragma mark -- 获取沙盒路径
+(NSString *)getHomePath;
#pragma mark -- 获取Document路径
+(NSString *)getDocumentPath;
#pragma mark -- 获取Library路径
+(NSString *)getLibraryPath;
#pragma mark -- 获取temp路径
+(NSString *)getTempPath;
+(void)creatFold;
+(void)writeFile;
#pragma mark -- 追加内容
+(void)addFile;
//写入沙盒缓存
+(void)writeToModel:(id)obj andKey:(NSString *)key;
//读取沙盒缓存
+(id)readFromModelKey:(NSString *)key;


#pragma mark --- 归档
+ (NSData *)archiverModel:(id)model modelKey:(NSString *)modelKey;
#pragma mark ---反归档(解档)
+(id)unArchiverModelFileKey:(NSString *)modelKey;

@end
