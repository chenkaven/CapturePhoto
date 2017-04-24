
#import "ZLCameraImageView.h"
#import "UIView+Extension.h"

@interface ZLCameraImageView ()

@property (assign, nonatomic) CGPoint point;

@property (strong, nonatomic) UIImageView *deleBjView;

@property (weak, nonatomic) UIView *mView;
/**
 *  记录所有的图片显示标记
 */
@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation ZLCameraImageView


- (UIImageView *)deleBjView{
    
    if (!_deleBjView) {
        
        _deleBjView = [[UIImageView alloc] init];
        //_deleBjView.image = [UIImage imageNamed:@"icon_goBack"];
        _deleBjView.image = ImageOfName(@"icon_goBack");
        _deleBjView.width = 25;
        _deleBjView.height = 25;
        _deleBjView.hidden = YES;
        _deleBjView.x = 75;
        _deleBjView.y = 10;
        _deleBjView.userInteractionEnabled = YES;
        [_deleBjView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleImage:)]];
        [self addSubview:_deleBjView];
    }
    return _deleBjView;
}

- (void)setEdit:(BOOL)edit{
    
    self.deleBjView.hidden = NO;
}

- (void)dealloc{
    [self.layer removeAllAnimations];
    
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        [self addRecognizer];
    }
    return self;
}

- (void)addRecognizer {
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self addGestureRecognizer:gesture1];
}

#pragma mark 删除图片
- (void) deleImage : ( UITapGestureRecognizer *) tap{
    
    if ([self.delegatge respondsToSelector:@selector(deleteImageView:)]) {
        
        [self.delegatge deleteImageView:self];
    }
}

- (void)handleGesture:(UITapGestureRecognizer *)gesture {
    
    // 防止多次点击
    self.userInteractionEnabled = NO;
    self.point = [gesture locationInView:self];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    if (self.originalImageView) {
        
        imageView.image = self.originalImageView;
    } else {
        
        imageView.image = self.image;
    }
    
    imageView.center = [self convertPoint:self.point fromView:self.superview];

    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture1:)];
    [imageView addGestureRecognizer:gesture1];
    [self.window addSubview:imageView];
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = self.window.frame;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)handleGesture1:(UITapGestureRecognizer *)gesture {
    
    UIView *view = gesture.view;
    [UIView animateWithDuration:0.5 animations:^{
        view.bounds = CGRectZero;
        CGPoint point = self.point;
        point.y = self.frame.origin.y + point.y;
        point.x = self.frame.origin.x + point.x;
        view.center = point;
        view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end



#pragma mark --- 导入拍照的Layer层


@implementation ZLCameraView

- (CADisplayLink *)link{
    
    if (!_link) {
        
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    }
    return _link;
}

- (void) refreshView : (CADisplayLink *) link{
    [self setNeedsDisplay];
    self.time++;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isPlayerEnd) return;
    
    self.isPlayerEnd = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    self.point = point;
    
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    if ([self.delegate respondsToSelector:@selector(cameraDidSelected:)]) {
        [self.delegate cameraDidSelected:self];
    }
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    if (self.isPlayerEnd) {
        
        CGFloat rectValue = BQCameraViewW - self.time % BQCameraViewW;
        
        CGRect rectangle = CGRectMake(self.point.x - rectValue / 2.0, self.point.y - rectValue / 2.0, rectValue, rectValue);
        //获得上下文句柄
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        if (rectValue <= 30) {
            self.isPlayerEnd = NO;
            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.link = nil;
            self.time = 0;
            
            CGContextClearRect(currentContext, rectangle);
            
        } else {
            //创建图形路径句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //设置矩形的边界
            //添加矩形到路径中
            CGPathAddRect(path,NULL, rectangle);
            //添加路径到上下文中
            CGContextAddPath(currentContext, path);
            
            //    //填充颜色
            [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:0] setFill];
            //设置画笔颜色
            [[UIColor yellowColor] setStroke];
            //设置边框线条宽度
            CGContextSetLineWidth(currentContext,1.0f);
            //画图
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            /* 释放路径 */
            CGPathRelease(path);
        }
    }
}
@end

