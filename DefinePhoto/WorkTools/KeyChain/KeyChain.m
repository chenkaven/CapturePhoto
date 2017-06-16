//
//  KeyChain.m
//  DefinePhoto
//
//  Created by addmin on 17/6/14.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "KeyChain.h"
#define kUserInfoFileName  @"customFile.txt"
#define kUserInfoDataKey  @"userInfo"

@interface KeyChain()


@end

@implementation KeyChain

static KeyChain  *shareKeyChain  = nil;

#pragma mark ------  单例初始化  -------
+(KeyChain *)shareInstance{
    
    if (shareKeyChain == nil ) {
        //static dispatch_once_t onceToken;
        //   dispatch_once(&onceToken, ^{
        //onceToken: 只走一次
        shareKeyChain = [[KeyChain alloc] init];
        //  });
    }
    return shareKeyChain;
}

#pragma mark -- 获取沙盒路径
+(NSString *)getHomePath{
    NSString  *homePath = NSHomeDirectory();
    NSLog(@"homePath===\n%@",homePath);
    return homePath;
}

#pragma mark -- 获取Document路径
+(NSString *)getDocumentPath{
    NSArray  *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString  *documentPath = [docPaths lastObject];
   NSLog(@"documentPath===\n%@",documentPath);
    return documentPath;
}
#pragma mark -- 获取Library路径
+(NSString *)getLibraryPath{
    NSArray  *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString  *libraryPath = [libPaths firstObject];
    NSLog(@"libraryPath===\n%@",libraryPath);
    return libraryPath;
}
#pragma mark -- 获取temp路径
+(NSString *)getTempPath{
    
    NSString  *tempPaths = NSTemporaryDirectory();
    NSLog(@"tempPaths===\n%@",tempPaths);
    return tempPaths;
}
#pragma mark -- 获取路径的组成部分
+(void)getFilePath{
  NSString *path = @"/data/containers/data/Application/test.png";
    //获得路径的各个组成部分
    NSArray  *arrry = [path pathComponents];
    NSLog(@"pathComponents ===\n%@",arrry);
    //提取路径的最后一个组成部分
    NSString *name = [path lastPathComponent];
    NSLog(@"fileName====\n%@",name);
    //删除路径的最后一个组成部分
    NSString  *string = [path stringByDeletingLastPathComponent];
    NSLog(@"lastPath=====\n%@",string);
    //追加name.txt
    NSString  *addStr = [path stringByAppendingPathComponent:@"name.txt"];
    NSLog(@"addStr=====\n%@",addStr);
}
#pragma mark --- 数据转换
+(void )dataChangeStr:(NSData *)data{
    //NSData ->NSString
    NSString  *aString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSString ->NSData
    NSData  *aData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSData->UIImage
    UIImage  *image = [UIImage imageWithData:aData];
    //UIImage ->NSData
    NSData *bData = UIImagePNGRepresentation(image);
    NSLog(@"bData=====%@",bData);
}

+(void)creatFold{

    NSString *docPath = [self getDocumentPath];
    NSString *textPath = [docPath stringByAppendingPathComponent:@"慕课网"];
    //文件夹管理器
    NSFileManager  *manger = [NSFileManager defaultManager];
   // ntermediateDirectories:  YES：可以覆盖  NO:不可以覆盖
   BOOL  ret =  [manger createDirectoryAtPath:textPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (ret) {
        NSLog(@"文件夹创建成功");
    }else{
        NSLog(@"文件夹创建失败");
    }
    //创建文件
    NSString  *textFile = [textPath stringByAppendingPathComponent:@"慕课网笔记.txt"];
    if (textFile) {
        NSFileManager  *mangerT =[NSFileManager defaultManager];
        BOOL retT = [mangerT createFileAtPath:textFile contents:nil attributes:nil];
        if (retT) {
            NSLog(@"创建文本成功");
        }else{
            NSLog(@"创建文本失败");
        }
    }
}

#pragma mark --- 对文件进行写入
+(void)writeFile{
    
    NSString  *docPath = [self getDocumentPath];
    //读取文件
    NSString *textPath = [docPath stringByAppendingPathComponent:@"慕课网"];
    NSString *filePath = [textPath stringByAppendingPathComponent:@"慕课网笔记.txt"];
    NSString *content  = @"羞辱三季度数据是否收费技术开发";
    BOOL ret  = [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (ret) {
        NSLog(@"写入文本成功");
    }else{
        NSLog(@"写入文本失败");
    }
}
#pragma mark -- 检测文件是否存在
+(BOOL)isfileExist:(NSString *)filePath{
    
    NSFileManager  *manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:filePath]) {
        return YES;
    } else {
            return NO;
    }
}
#pragma mark -- 追加内容
+(void)addFile{

    NSString  *docPath = [self getDocumentPath];
    //读取文件
    NSString *textPath = [docPath stringByAppendingPathComponent:@"慕课网"];
    NSString *filePath = [textPath stringByAppendingPathComponent:@"慕课网笔记.txt"];
    //打开文件 -- 准备更新
    NSFileHandle  *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    //将节点跳到文件的末尾
    [fileHandle seekToEndOfFile];
    NSString  *stringData =@"这是我要新加的内容";
    NSData  *dataStr =  [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:dataStr];
    //关闭文件
    [fileHandle closeFile];
}
#pragma mark --- 写入沙盒缓存
+(void)writeToModel:(id)obj andKey:(NSString *)key {
    
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    [userD setObject:obj forKey:key];
    [userD synchronize];
}
#pragma mark --- 读取沙盒缓存
+(id)readFromModelKey:(NSString *)key{
    
    NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
    return [userD objectForKey:key];
}

#pragma mark --- 归档
/**路径*/
+ (NSString *)filePathComponentName:(NSString *)fileName{
    NSLog(@"沙盒地址%@",NSHomeDirectory());
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]     stringByAppendingPathComponent:fileName];
    
}
//归档的方法1
+ (NSData *)archiverModel:(id)model modelKey:(NSString *)modelKey {
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:modelKey];
    [archiver finishEncoding];
    //写入沙盒缓存
    [KeyChain writeToModel:data andKey:modelKey];
    return data;
}
//归档的方法2
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //保存值
    NSLog(@"执行了归档的方法");
}


#pragma mark ---反归档(解档)
+(id)unArchiverModelFileKey:(NSString *)modelKey {
    
    NSData   *data = [KeyChain readFromModelKey:modelKey];
    // 3.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    // 4.进行对model的反归档读取
    id model = [unArchiver decodeObjectForKey:modelKey];
    [unArchiver finishDecoding];
    if (model == nil) {
        NSLog(@"读档信息为空");
    }
    return model;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        //取值
        //self.userName = [aDecoder decodeObjectForKey:@"userName"];
        //self.userPhone = [aDecoder decodeObjectForKey:@"userPhone"];
        //self.userAge = [aDecoder decodeIntegerForKey:@"userAge"];
        //  _model = [aDecoder decodeObjectForKey:_modelKey];
        NSLog(@"执行了反归(解)档的方法");
    }
    return self;
}
@end
