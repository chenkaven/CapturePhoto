//
//  CustomDefine.h
//  MacCustomDevelop
//
//  Created by kaven on 2017/3/20.
//  Copyright © 2017年 kaven. All rights reserved.
//

#ifndef CustomDefine_h
#define CustomDefine_h


//弱引用/强引用

#define kWeakSelf(type)   __weak typeof(type) weak##type = type;

#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//判断字符串为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//判断数组为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典为空
#define kDictIsEmpty(dic)    (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象

#define kObjectIsEmpty(_object) (_object == nil \ || [_object isKindOfClass:[NSNull class]] \ || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \ || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))




/* 图片和字体赋值 */
#define ZiFontOfSize(Font)     [UIFont systemFontOfSize:Font]
#define ImageOfName(Image)     [UIImage imageNamed:Image]

//一些缩写

#define kApplication           [UIApplication sharedApplication]

#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#define kAppDelegate        [UIApplication sharedApplication].delegate

#define APPINSTANCE(app)        AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate


/* 本地写入缓存的宏定义 */
#define kUserDefaults                         [NSUserDefaults standardUserDefaults]
//写入缓存
#define kWriteUserDefaults(Model,keyStr)      [kUserDefaults setObject:Model forKey:keyStr],[kUserDefaults synchronize]
//读取缓存
#define kGetUserDefaults(keyStr)              [kUserDefaults objectForKey:keyStr]
//清空缓存
#define kRemoveUserDefaults(keyStr)           [kUserDefaults removeObjectForKey:keyStr]  / [kUserDefaults synchronize]


/* 发送通知的宏定义 */
#define kNotificationCenter                           [NSNotificationCenter defaultCenter]
//发送通知
#define kPostNotic(notName)                           [kNotificationCenter postNotificationName:notName object:nil]
//发送通知传值
#define kPostModelNotic(notName,model)                [kNotificationCenter postNotificationName:notName object:nil userInfo:model]
//接收通知方法
#define kAddObserNotic(type,methods,notiName)          [kNotificationCenter addObserver:type selector:@selector(methods) name:notiName object:nil];
//移除通知
#define kRemoveNotic(notObserver)                      [kNotificationCenter removeObserver:notObserver]
//指定对象移除通知
#define kRemoveObverNotic(notObserver,noticName)      [kNotificationCenter removeObserver:notObserver name:noticName object:nil]

//xib文件读取
#define kXIBFileWritieView(xibName)         [[[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil]lastObject]





//获取沙盒Document路径

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒temp路径

#define kTempPath NSTemporaryDirectory()

//获取沙盒Cache路径

#define kCachePath    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]



//颜色

#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

#define kColorWithHex(rgbValue) \ [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \ green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \ blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define HEXCOLOR(hex)           [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]


//由角度转换弧度

#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)

//由弧度转换角度

#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)



//获取一段时间间隔

#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)



//开发的时候打印，但是发布的时候不打印的NSLog

#ifdef DEBUG

#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else

#define NSLog(...)

#endif



#endif /* CustomDefine_h */
