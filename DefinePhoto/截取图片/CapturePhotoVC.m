//
//  CapturePhotoVC.m
//  DefinePhoto
//
//  Created by kaven on 2017/4/21.
//  Copyright © 2017年 kaven. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CapturePhotoVC.h"
#import "ZLCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVAsset.h>
#import <MobileCoreServices/UTCoreTypes.h>

#define ImageName1          @"http://tp2.sinaimg.cn/1829483361/50/5753078359/1"
#define ImageName2          @"https://avatars0.githubusercontent.com/u/8408918?v=3&s=460"
#define ImageURL1           [NSURL URLWithString:ImageName1]
#define ImageURL2           [NSURL URLWithString:ImageName2]
#define PlaceholderImage    ImageOfName(@"Default1.jpg")


#define CUTKIND_USERICON     2
#define PictureMaxSize       1500 * 1500
#define PictureFitSize       1080


@interface CapturePhotoVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UIImageView *photoView;

@end

@implementation CapturePhotoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    /* 自动滚动调整，默认为YES */
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*设置导航透明NO:  --则self.view.bounds.size.height 变为原高度 - 64 ;Yes:反之*/
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择图片截图";
    
    [self initCustomView];
}
//初始化界面
-(void)initCustomView{
    
    [self photoView];
}

#pragma mark -- UIMagePickControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    kWeakSelf(self);
    NSString *mediaType= [info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
       if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //如果是图片
       UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //压缩图片
      //  NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //保存图片至相册
     //   UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [weakself capturePhotoVCtoImage:image];

        //上传图片
       // [self uploadImageWithData:fileData];
        
    }else{
    
    }
    
      [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImageView *)photoView{
    
    if (!_photoView) {
        
        _photoView = [[UIImageView alloc]init];
        _photoView.frame = MainScreenSize(20, 0, 120, 120);
        _photoView.backgroundColor = kRGBColor(20, 35, 46);
        //开启用户交互
        _photoView.userInteractionEnabled = YES;
        //_photoView.image = ImageOfName(@"1.jpg");
        //赋值图片
        [_photoView sd_setImageWithURL:ImageURL2 placeholderImage:PlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            image =  [UIImage  imageCompressForWidth:image targetWidth:MainScreenWidth - 20];
            // image = [UIImage imageCompressForHeight:image targetHeight:320];
            //   image =  [UIImage   imageCompressForSize:image targetSize:CGSizeMake(MainScreenWidth - 20, MainScreenHeight - 84)];
            
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            _photoView.frame = MainScreenSize(10, 10,  imageWidth, imageHeight);
            //给图片添加点击事件
            UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnAction:)];
            [_photoView addGestureRecognizer:tap];
            
            
        }];
        [self.view addSubview:_photoView];
        
    }
    return _photoView;
}
#pragma mark -- 图片点击方法
-(void)tapBtnAction:(UITapGestureRecognizer *)tap{
    
    kWeakSelf(self)
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                       {
                           [weakself openPhoto];
                       }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"选择相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                       {
                           [weakself takePhoto];
                       }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                       { }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)openPhoto{
    
    //打开相册
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController * imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = sourceType;
    imagePick.delegate = self;
    imagePick.allowsEditing = NO;
    [self presentViewController:imagePick animated:YES completion:NULL];
}

-(void)takePhoto{
    
    kWeakSelf(self);
    //    //打开相机1
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    //        //如果有相机（因为模拟器没有
    //        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //        UIImagePickerController * imagePick = [[UIImagePickerController alloc] init];
    //        imagePick.sourceType = sourceType;
    //        imagePick.delegate = self;
    //        imagePick.allowsEditing = NO;
    //        [self presentViewController:imagePick animated:YES completion:NULL];
    //    } else {
    //
    //        NSLog(@"没有相机");
    //    }
    //打开相机2
    
    ZLCameraViewController *camreaVc = [[ZLCameraViewController alloc] init];
    //camreaVc.complate = self.complate;
    camreaVc.complate = ^(NSArray *photoArr){
        
        if ([[photoArr firstObject] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary  *dict = [photoArr firstObject];
            //取出所有的键值
            NSArray *arr = [dict allKeys];
            //根据对应的键值取出所有的value
            UIImage  *image =  dict[[arr firstObject]];
            //开启截图
            [weakself capturePhotoVCtoImage:image];
            image = [UIImage imageCompressForWidth:image targetWidth:MainScreenWidth - 20];
            self.photoView.image = image;
        }
        
    };
    [self.navigationController presentViewController:camreaVc animated:YES completion:nil];
    
}
#pragma mark -- 截图控制器
-(void)capturePhotoVCtoImage:(UIImage *)image{
    
    kWeakSelf(self)
    UIImage *photoImage = nil;
    // 如果图片太大  则对图片进行压缩
    if (image.size.width * image.size.height > PictureMaxSize) {
        
        // 压缩图片的质量
        photoImage = [UIImage imageCompressForWidth:image targetWidth:PictureFitSize];
        
    } else {
        
        photoImage = image;
    }
    // 如果该图片大于2M，会自动旋转90度；否则不旋转 解决这问题的方法
    photoImage = [photoImage fixOrientation];
    // 裁剪
    CGRect frame = CGRectMake(40, (64 + (MainScreenHeight - 64 - 50 - (MainScreenWidth - 2 * 40))) / 2, MainScreenWidth - 2 * 40, MainScreenWidth - 2 * 40) ;
    
    VPImageCropperViewController  *imgEditorVC = [[VPImageCropperViewController alloc]initWithImage:photoImage cropFrame:frame limitScaleRatio:3.0];
    
    imgEditorVC.cutKind = CUTKIND_USERICON;
    imgEditorVC.isCropUserPhoto = NO;
    imgEditorVC.userIconBlock = ^(UIImage *img) {
        
        //[selfVC uploadUserHeadImgNetworkData:img];
        NSLog(@"打印%@",img);
        [weakself.photoView setImage:img];
    };
    [self.navigationController pushViewController:imgEditorVC animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
