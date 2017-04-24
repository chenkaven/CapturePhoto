//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM( int, CUT_KIND ) {
    /*美容前的照片*/
    CUT_KIND_PRE_PHOTO = 0,
    /*美容后的照片*/
    CUT_KIND_POST_PHOTO,
    /*用户头像*/
    CUT_KIND_USERICON
    
};

@class VPImageCropperViewController;

typedef void (^UserIconBlock)(UIImage *user_Img);

@interface VPImageCropperViewController : UIViewController

@property (copy, nonatomic) UserIconBlock userIconBlock;
/*设置剪切的大小*/
@property (nonatomic, assign) CGRect cropFrame;

/*设置剪切之后返回的地方*/
@property (assign, nonatomic) CUT_KIND cutKind;

/*返回方法*/
@property (assign, nonatomic) int returnMethod;

/*设置按钮是否使用协议方法*/
@property (assign, nonatomic) BOOL isCropUserPhoto;

/**
 *  引用这个类的初始化方法
 *
 *  @param originalImage 导入图片
 *  @param cropFrame     导入这个图片显示的大小
 *  @param limitRatio    缩放系数
 *
 *  @return <#return value description#>
 */
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
