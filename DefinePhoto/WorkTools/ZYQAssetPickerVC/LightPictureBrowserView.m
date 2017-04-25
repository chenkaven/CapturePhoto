/*
 
  图片浏览器  --支持点击放大和缩小
  支持捏合 放大 和 缩小

*/


#import "LightPictureBrowserView.h"

#pragma mark   -- 宏定义

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define DEVICE_W [UIScreen mainScreen].bounds.size.width
#define DEVICE_H [UIScreen mainScreen].bounds.size.height

@interface LightPictureBrowserView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *showImagesCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSArray *imagesUrlArray;
@property (assign, nonatomic) int totalPage;


@end

static LightPictureBrowserView *lightPictureBrowser = nil;

@implementation LightPictureBrowserView


+(LightPictureBrowserView *)sharedLightPictureBrowserView{
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        
        lightPictureBrowser = [[LightPictureBrowserView alloc]init];
    });
    
    return lightPictureBrowser;
}

//重写父类方法
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (lightPictureBrowser == nil) {
        lightPictureBrowser = [[super allocWithZone:zone]init];
    }
    return lightPictureBrowser;
}

//实现NSCopying协议内方法
- (id)copyWithZone:(nullable NSZone *)zone{
    
    return lightPictureBrowser;
}

//实现NSMutableCopying协议内方法
-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return lightPictureBrowser;
}

//---界面初始化
-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
        [self setBackgroundColor:[UIColor blackColor]];
        [APPDELEGATE.window addSubview:self];
        //添加初始化CollectViw
        [self demoCollectionViewController];
        //添加到window
        [self addSubview:self.showImagesCollectionView];
    }
    
    return self;
}
-(void)demoCollectionViewController {
    
    //初始化UICollectionFlowLayout
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [_flowLayout setItemSize:CGSizeMake(DEVICE_W, DEVICE_H)];//设置每个单元格的size
    [_flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];//内边距设为0
    [_flowLayout setMinimumInteritemSpacing:0.0];//单元格间距设为0
    [_flowLayout setMinimumLineSpacing:0.0];//行间距设为0
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//水平滚动
    //初始化UICollectionView
    _showImagesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H) collectionViewLayout:self.flowLayout];
    [_showImagesCollectionView setDelegate:self];
    [_showImagesCollectionView setDataSource:self];
    [_showImagesCollectionView setBackgroundColor:[UIColor clearColor]];
    
    //注册单元格
    [_showImagesCollectionView registerClass:[CustomPictureBrowserCell class] forCellWithReuseIdentifier:@"reuseCell"];
    
    [_showImagesCollectionView setPagingEnabled:YES];
    [_showImagesCollectionView setShowsHorizontalScrollIndicator:NO];
    [_showImagesCollectionView setBounces:NO];//关闭回弹效果
}

/**
 *  显示来自网络的图片
 *
 *  @param imagesUrlArray       存储图片链接的数组
 *  @param placeholderImageName 下载完成前的占位图名称
 *  @param index                显示图片的开始位置
 *  @param fromPoint            显示图片的起始点
 */
-(void)showImageWithUrlArray:(NSArray *)imagesUrlArray andPlaceholderImageName:(NSString *)placeholderImageName andIndex:(int)index andStartFromPosition:(CGPoint)fromPoint {
    
    self.imagesUrlArray = imagesUrlArray;
    self.totalPage = (int)[_imagesUrlArray count];
    //刷新showImagesCollectionView
    [self.showImagesCollectionView reloadData];
    //通过index 滚动到对应的位置
    [self.showImagesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //开启隐藏
    [self setHidden:NO];
    //设置打开动画效果
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1) ;
    //设置关闭动画效果
    [UIView animateWithDuration:0.2 animations:^{
        
        self.center = APPDELEGATE.window.center;
        self.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1) ;
    }];

}

#pragma mark - 实现UICollectionViewDataSource协议内的方法

//返回对应分区的行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imagesUrlArray.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomPictureBrowserCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCell" forIndexPath:indexPath];
    //判断---传过来的数据
    //1、本地图片
    if ([[_imagesUrlArray firstObject] isKindOfClass:[UIImage class]]){
        
      [customCell updateViewsWithImage:_imagesUrlArray[indexPath.row] andPlaceholderImageName:nil andCurrentPage:(int)(indexPath.row + 1) andTotalPage:_totalPage];
        
    } else if ([[_imagesUrlArray firstObject] isKindOfClass:[NSString class]]){
      //2、网络图片地址
        [customCell updateViewsWithImageUrl:_imagesUrlArray[indexPath.row] andPlaceholderImageName:nil andCurrentPage:(int)(indexPath.row + 1) andTotalPage:_totalPage];
  
    }
        

    __weak typeof(self) weakSelf = self;
    //隐藏图片浏览器
    customCell.hidePictureBrowserBlock = ^(){
        //设置关闭动画效果
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.center = APPDELEGATE.window.center;
            weakSelf.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1) ;
        }];
        [weakSelf performSelector:@selector(hiddenPictureBrowser) withObject:nil afterDelay:0.2];
    };
    
    return customCell;
}

//隐藏图片浏览器
-(void)hiddenPictureBrowser{
    
    [self setHidden:YES];
}
@end

#pragma mark --- CustomPictureBrowserCell

@interface CustomPictureBrowserCell ()<UIScrollViewDelegate> {
    
//    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UIScrollView *showImageScrollView;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *currentPageLabel;
@property (assign, nonatomic) int  totalPag;
@property (strong, nonatomic) NSString * isnet;//判断是否有网络
@end

@implementation CustomPictureBrowserCell

//初始化单元格

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        //初始化视图
        [self initViewsCustomCell];
    }
    return self;
}


/**
 *  初始化视图
 */
-(void)initViewsCustomCell{
    
    //创建页面指示器
    _currentPageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DEVICE_H - 30, DEVICE_W, 20)];
    [_currentPageLabel setBackgroundColor:[UIColor clearColor]];
    [_currentPageLabel setTextAlignment:NSTextAlignmentCenter];
    [_currentPageLabel setTextColor:[UIColor whiteColor]];
    [_currentPageLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_currentPageLabel setText:@" / "];
    
    //创建图片
    _imgView = [[UIImageView alloc]init];
    [_imgView setCenter:self.showImageScrollView.center];
    [_imgView setUserInteractionEnabled:YES];
    
    //双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_imgView addGestureRecognizer:doubleTapGesture];
    
    //单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [_imgView addGestureRecognizer:singleTapGesture];
    
    //创建_showImageScrollView  创建广告轮播
    _showImageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
    [_showImageScrollView setShowsVerticalScrollIndicator:YES];
    [_showImageScrollView setShowsHorizontalScrollIndicator:YES];
    [_showImageScrollView setBackgroundColor:[UIColor clearColor]];
    
    [_showImageScrollView setMinimumZoomScale:1.0]; //设置最小倍数
    [_showImageScrollView setMaximumZoomScale:3.0];//设置最高放大倍数
    [_showImageScrollView setDelegate:self];//设置委托代理
    [_showImageScrollView addSubview:self.imgView];
    
    [self.contentView addSubview:self.showImageScrollView];
    [self.contentView addSubview:self.currentPageLabel];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
}

-(void)updateViewsWithImage:(UIImage *)imageName andPlaceholderImageName:(NSString *)placeholderImageName andCurrentPage:(int)currentPage andTotalPage:(int)totalPage {
    
    _totalPag = totalPage;
    _showImageScrollView.contentSize = CGSizeMake(totalPage*DEVICE_W, DEVICE_H);
    [_showImageScrollView setZoomScale:1.0];
    [_currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",currentPage,totalPage]];
    __weak typeof(self) weakSelf = self;
    self.imgView.image  = imageName;
    //展示imageview的Frame
    weakSelf.imgView.frame = [self caculateOriginImageSizeWith:imageName];
    
}
/**
 *  更新单元格视图
 *
 *  @param imgUrlStr            图片链接（字符串）
 *  @param placeholderImageName 下载完成前的占位图名称
 *  @param currentPage          当前页码
 *  @param totalPage            总页数
 */
-(void)updateViewsWithImageUrl:(NSString *)imgUrlStr andPlaceholderImageName:(NSString *)placeholderImageName andCurrentPage:(int)currentPage andTotalPage:(int)totalPage {
    
    //总计
    _totalPag = totalPage;
    _showImageScrollView.contentSize =CGSizeMake(totalPage*DEVICE_W, DEVICE_H);
    [_showImageScrollView setZoomScale:1.0];
    [_currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",currentPage,totalPage]];
    //强调弱引用
    __weak typeof(self) weakSelf = self;
    //      NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrlStr]];
    //     [self.imgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //            //展示imageview的Frame
    //            weakSelf.imgView.frame =[self caculateOriginImageSizeWith:image];
    //
    //        }];
    //添加图片
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL isCached = [manager cachedImageExistsForURL:[NSURL URLWithString:imgUrlStr]];
    
    if (!isCached) {
        //没有缓存
//        HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        HUD.mode = MBProgressHUDModeDeterminate;
        
        [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
            
//            HUD.progress = ((float)receivedSize)/expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            
            weakSelf.imgView.frame = [self caculateOriginImageSizeWith:image];
        
            if (!isCached) {
                
//                [HUD hide:YES];
            }
        }];
    }else{
        //直接取出缓存的图片，减少流量消耗
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrlStr];
        weakSelf.imgView.frame = [self caculateOriginImageSizeWith:cachedImage];
        weakSelf.imgView.image = cachedImage;
    }
    
    
    
}



#pragma mark - 实现UIScrollViewDelegate协议内的方法放大或缩小的代理

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (_showImageScrollView.bounds.size.width > _showImageScrollView.contentSize.width)?(_showImageScrollView.bounds.size.width - _showImageScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (_showImageScrollView.bounds.size.height > _showImageScrollView.contentSize.height)?
    (_showImageScrollView.bounds.size.height - _showImageScrollView.contentSize.height) * 0.5 : 0.0;
    self.imgView.center = CGPointMake(_showImageScrollView.contentSize.width * 0.5 + offsetX,_showImageScrollView.contentSize.height * 0.5 + offsetY);
    
}

//返回要缩放的图片视图imgView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}


#pragma mark - 图片的双击手势

/**
 *  双击手势响应方法
 *
 *  @param tapGestureSender 双击手势的发起者
 */
-(void)doubleTapGestureAction:(UITapGestureRecognizer *)tapGestureSender{
    
    
    if (tapGestureSender.numberOfTapsRequired == 2) {
        
        if(_showImageScrollView.zoomScale == 1) {
            //双击扩大3倍
            float newScale = [_showImageScrollView zoomScale] *3;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGestureSender locationInView:tapGestureSender.view]];
            [_showImageScrollView zoomToRect:zoomRect animated:YES];
        } else {
            //双击缩小3呗
            float newScale = [_showImageScrollView zoomScale]/3;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGestureSender locationInView:tapGestureSender.view]];
            [_showImageScrollView zoomToRect:zoomRect animated:YES];
        }
    }
    
}

#pragma mark - 图片的单击手势

-(void)singleTapGestureAction{
    
    //调用代码块，隐藏图片浏览器
    if (self.hidePictureBrowserBlock) {
        
        self.hidePictureBrowserBlock();
    }
    
}


#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_showImageScrollView frame].size.height/scale;
    zoomRect.size.width = [_showImageScrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}
#pragma mark - 计算图片原始高度，用于高度自适应
-(CGRect)caculateOriginImageSizeWith:(UIImage *)image{
    
    CGFloat originImageHeight=[self imageCompressForWidth:image targetWidth:DEVICE_W].size.height;
    if (originImageHeight>=DEVICE_H) {
        
        originImageHeight=DEVICE_H;
    }
    
    CGRect frame=CGRectMake(0, (DEVICE_H-originImageHeight)*0.5, DEVICE_W, originImageHeight);
    
    return frame;
}

/**指定宽度按比例缩放图片*/
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}



@end

