
#import <UIKit/UIKit.h>

@class ZLCameraImageView;

@protocol ZLCameraImageViewDelegate <NSObject>

@optional
/**
 *  根据index来删除照片
 *
 */
- (void ) deleteImageView : (ZLCameraImageView *) imageView;

@end

@interface ZLCameraImageView : UIImageView

@property (strong, nonatomic) UIImage *originalImageView;

@property (weak, nonatomic) id <ZLCameraImageViewDelegate> delegatge;

@property (assign, nonatomic) NSInteger index;
/**
 *  是否是编辑模式 , YES 代表是
 */
@property (assign, nonatomic, getter = isEdit) BOOL edit;


@end



#pragma mark --- 导入拍照的Layer层

@class ZLCameraView;

@protocol ZLCameraViewDelegate <NSObject>

@optional

- (void) cameraDidSelected : (ZLCameraView *) camera;

@end

#define BQCameraViewW 60

@interface ZLCameraView : UIView

@property (weak, nonatomic) id <ZLCameraViewDelegate> delegate;
@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) CGPoint point;
@property (assign, nonatomic) BOOL isPlayerEnd;

@end
