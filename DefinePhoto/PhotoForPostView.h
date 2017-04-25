//
//  PhotoForPostView.h
//  Dfhon
//
//  Created by 1 on 15-4-17.
//  Copyright (c) 2015年 com.soshow.org. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

//图片浏览器
#import "LightPictureBrowserView.h"

@protocol PhotoForPostViewDelegate <NSObject>

@optional

- (void)refreshHeight;

@end

@interface PhotoForPostView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton * cameraButton;
@property (strong, nonatomic) UIButton * deleteButton;

@property (assign, nonatomic) UIViewController <PhotoForPostViewDelegate> * baseVC;

@property (strong, nonatomic) NSMutableArray * arrForSavePhotos;


@end
