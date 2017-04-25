
#pragma mark --  LightPictureBrowserView

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//第三方文件
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
//#import "MBProgressHUD.h"

@interface LightPictureBrowserView : UIView

+(LightPictureBrowserView *)sharedLightPictureBrowserView;

/**
 *  显示来自网络的图片
 *
 *  @param imagesUrlArray       存储图片链接的数组
 *  @param placeholderImageName 下载完成前的占位图名称
 *  @param index                显示图片的开始位置
 *  @param fromPoint            显示图片的起始点
 */
-(void)showImageWithUrlArray:(NSArray *)imagesUrlArray andPlaceholderImageName:(NSString *)placeholderImageName andIndex:(int)index andStartFromPosition:(CGPoint)fromPoint;

@end

#pragma mark  -- CustomPictureBrowserCell


//隐藏图片浏览器
typedef void(^HidePictureBrowserBlock)();

@interface CustomPictureBrowserCell : UICollectionViewCell

@property (copy, nonatomic) HidePictureBrowserBlock hidePictureBrowserBlock;

/**
 *  更新单元格视图
 *
 *  @param imgUrlStr            图片链接（字符串）
 *  @param placeholderImageName 下载完成前的占位图名称
 *  @param currentPage          当前页码
 *  @param totalPage            总页数
 */
//1、本地--图片
-(void)updateViewsWithImage:(UIImage *)imgUrlStr andPlaceholderImageName:(NSString *)placeholderImageName andCurrentPage:(int)currentPage andTotalPage:(int)totalPage;

//2、网络--图片地址
-(void)updateViewsWithImageUrl:(NSString *)imgUrlStr andPlaceholderImageName:(NSString *)placeholderImageName andCurrentPage:(int)currentPage andTotalPage:(int)totalPage;


@end


