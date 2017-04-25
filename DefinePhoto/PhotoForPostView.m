//
//  PhotoForPostView.m
//  Dfhon
//
//  Created by 1 on 15-4-17.
//  Copyright (c) 2015年 com.soshow.org. All rights reserved.
//

#import "UIView+Extension.h"
#import "PhotoForPostView.h"
#import "ZYQAssetPickerController.h"
//挑选类
#define  AssetsFilter      [ALAssetsFilter allPhotos]
//选择类
#define  SelectionFilter   [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings){ if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) { NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];  return duration >= 5; } else { return YES; } }]
//选择最多的图片数
#define MaximumNumberOfSelection   6
@interface PhotoForPostView() <ZYQAssetPickerControllerDelegate,UINavigationBarDelegate>

@end

@implementation PhotoForPostView {
    float singleLenth;
    
    NSMutableArray * arrForImageView;
    NSMutableArray * arrForDeleteBtn;
}
#pragma mark - ZYQAssetPickerController Delegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       for (int i=0; i<assets.count; i++) {
                           
                           ALAsset *asset = assets[i];
                           UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                         
                           
                            dispatch_async(dispatch_get_main_queue(), ^{
                               //添加完成后成后恢复view视图
                                [self saveImage:tempImg];
                           });
                       }
                   });
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        
        singleLenth = (frame.size.width - 80)/3;
        
        _cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, singleLenth, singleLenth)];
//        [_cameraButton setImage:[UIImage imageNamed:@"picselectbtn"] forState:UIControlStateNormal];
        [_cameraButton setBackgroundImage:[UIImage imageNamed:@"picselectbtn"] forState:UIControlStateNormal];
        _cameraButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_cameraButton addTarget:self action:@selector(takePhotos:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraButton];
        
        
        _arrForSavePhotos = [[NSMutableArray alloc]initWithCapacity:50];
        
        arrForImageView = [[NSMutableArray alloc]initWithCapacity:50];
        
        arrForDeleteBtn = [[NSMutableArray alloc]initWithCapacity:50];
    }
    return self;
}

- (void)takePhotos:(UIButton *)sender {
    
    UIView *view = self.superview.superview.superview.superview;
    [view endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.superview];
}

//ActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //拍照操作
    if (actionSheet.tag == 1) {
        
        if (buttonIndex == 0) {
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
            [_baseVC presentViewController:imagePicker animated:YES completion:nil];
            
            
        } else if (buttonIndex == 1){
            
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = NO;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [_baseVC presentViewController:imagePicker animated:YES completion:nil];
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = MaximumNumberOfSelection - _arrForSavePhotos.count;
            //相册的类：
            picker.assetsFilter = AssetsFilter;
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            picker.selectionFilter = SelectionFilter;
            [_baseVC presentViewController:picker animated:YES completion:nil];
            
        } else {
            
            return;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片-进行压缩
- (void)saveImage:(UIImage *)image {
    
   UIImage *zipImage = [self zipImageData:image];
    [_arrForSavePhotos addObject:zipImage];
    [self reloadPhotosView];
 
}

/**
 *  判断图片大小压缩图片质量
 *
 *  @param image 传入图片UIImage
 *
 *  @return UIImage
 */
- (UIImage*)zipImageData:(UIImage*)image {
    
    UIImage *smallImage = nil;
    float imageScale;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    CGFloat imageSize = [imageData length] / 1024;  // 大小是：Kb
    if (imageSize >= 80) {
        
        if (imageSize >= 80 && imageSize < 500) {
            
            imageScale = 0.3;
            
        } else if (imageSize >= 500 && imageSize < 1024) {
            
            imageScale = 0.2;
        } else {
            
            imageScale = 0.1;
        }
        NSData *data = UIImageJPEGRepresentation(image, imageScale);
        smallImage = [UIImage imageWithData:data];

    } else {
        
        smallImage = image;
    }
    return smallImage;
}



//改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        //clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


//保持长宽比 固定宽度 生成小图片
- (UIImage *)scaleFromImage:(UIImage *) image toWidth:(CGFloat)width
{
    UIImage * newimage;
    
    if (image == nil) {
        
        newimage = nil;
        
    } else {
        
        CGSize oldSize = image.size;
        
        CGSize newSize;
        newSize.width = width;
        newSize.height = (oldSize.height/oldSize.width)*width;
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newimage;
}


- (void)reloadPhotosView {
    
    //清除所有原来子视图
    for (UIImageView * v in arrForImageView) {
        
        [v removeFromSuperview];
        
    }
    for (UIButton * b in arrForDeleteBtn) {
        
        [b removeFromSuperview];
    }
    
    int count = (int)_arrForSavePhotos.count;
    
    
    
    for (int i = 0; i < count; i++) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + (singleLenth + 20) * (i%3), 20 + (singleLenth + 20) * (i/3), singleLenth, singleLenth)];
        [arrForImageView addObject:imageView];
        
        
        imageView.image = _arrForSavePhotos[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;//设置图片填充模式
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + 10;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [self addSubview:imageView];
        
        
        UIButton * deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        [arrForDeleteBtn addObject:deleteBtn];
        
        
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_goBack"] forState:UIControlStateNormal];
        deleteBtn.center = CGPointMake(imageView.right, imageView.top);
        deleteBtn.tag = i + 10;
        [deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
    }
    
    _cameraButton.left = 20 + (singleLenth + 20) * (count%3);
    _cameraButton.top = 20 + (singleLenth + 20) * (count/3);
    
    self.height = _cameraButton.bottom + 20;
    
    
    if (_baseVC && [_baseVC respondsToSelector:@selector(refreshHeight)]) {
        
        [_baseVC refreshHeight];
    }
    if (count == 6) {
        
        _cameraButton.hidden = YES;
        _cameraButton.enabled = NO;
    } else {
    
        _cameraButton.hidden = NO;
        _cameraButton.enabled = YES;
    }
}


- (void)tapImage:(UITapGestureRecognizer *)image {
//    [FSPhotoView showImageWithSenderView:(UIImageView*)tap.view];
    
    UIImageView *imageView =(UIImageView *)image.view;
    int indexC = (int)imageView.tag - 10;
    LightPictureBrowserView *lightPictureBrowserView = [LightPictureBrowserView sharedLightPictureBrowserView];
    [lightPictureBrowserView showImageWithUrlArray:_arrForSavePhotos andPlaceholderImageName:nil andIndex:indexC andStartFromPosition:self.center];
}


- (void)deletePhoto:(UIButton *)sender {
    
    UIImageView * imgV = arrForImageView[sender.tag - 10];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        imgV.alpha = 0.5;
        sender.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        [_arrForSavePhotos removeObjectAtIndex:sender.tag - 10];
        [self reloadPhotosView];
        
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
