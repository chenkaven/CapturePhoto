//
//  GetSystemInfo.h
//  CustomDevelop
//
//  Created by kaven on 2017/4/20.
//  Copyright © 2017年 kaven. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GetSystemInfo : NSObject
//单例
//+(instancetype) shareInstance;
// 获取系统电量

+(void)getBatteryMoniter;
//获取设备连接WiFi名称
+ (NSString *)getWifiName;

//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4;

 // 获取运营商信息
+ (NSString *)getTelephonyInfo;

//手机型号iphone 6s
+ (NSString *)getDeviceModel;

@end
