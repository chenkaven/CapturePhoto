

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^codeBlock)();
typedef void(^ZLComplate)(NSArray *photoArr);

@interface ZLCameraViewController : UIViewController

// 完成后回调
@property (copy, nonatomic) ZLComplate complate;

@end
