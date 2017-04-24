//
//  KsystemDefine.h
//  DefinePhoto
//
//  Created by kaven on 2017/4/24.
//  Copyright © 2017年 kaven. All rights reserved.
//

//APP版本号
#define kAppVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断系统
#define IOS7            [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define IOS8            [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define UNDERIOS9       [[[UIDevice currentDevice]systemVersion] floatValue] < 9.0

//屏幕尺寸
#define IPHONE4      640  * 960
#define IPHONE5      640  * 1136
#define IPHONE6      750  * 1334
#define IPHONE6P     1080 * 1920
#define IPHONE7      1334 * 750
#define IPHONE7P     1920 * 1080

//获取屏幕宽度与高度

#define MainScreenHeight        [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth         [UIScreen mainScreen].bounds.size.width

//设置屏幕位置
#define MainScreenSize(x,y,w,h)        CGRectMake(x, y, w, h)





//判断是真机还是模拟器

#if TARGET_OS_IPHONE
//真机
#endif

#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

