//
//  UIImage+Define.h
//  MacCustomDevelop
//
//  Created by kaven on 2017/4/19.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Define)

#pragma mark --按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
#pragma mark  指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  等比压缩
 *
 *  @param sourceImage
 *  @param defineWidth 指定压缩的高度
 *
 *  @return 压缩后的图片
 */
+ (UIImage *) imageCompressForHeight:(UIImage *)sourceImage targetHeight:(CGFloat)defineHeight;
//截图
+ (UIImage *)getCut:(UIView *)view;
/**
 *  判断图片大小压缩图片质量
 *
 *  @param image 传入图片UIImage
 *
 *  @return UIImage
 */
+ (UIImage *)zipImageData:(UIImage * )image;

#pragma mark - fix orientation

- (UIImage *)fixOrientation;
@end
