//
//  ZYImageBrowser.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/2/27.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYImageBrowser.h"
#import "ZYImageCell.h"
@interface ZYImageBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray * photos;
@property(nonatomic,strong)UICollectionView *iCollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *iFlowLayout;
@property(nonatomic,strong)UIWindow *photoWindow;
@property(nonatomic,strong)UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong)UITapGestureRecognizer *singleTapGesture;
@property(nonatomic,strong)UITapGestureRecognizer *doubleTapGesture;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGesture;
@property(nonatomic,strong)ZYImageItem *currentItem;

@end

#define ZYViewWidth self.view.bounds.size.width
#define ZYViewHeight self.view.bounds.size.height
#define ZYScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZYScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ZYImageBrowser
{
    NSUInteger _currentIndex;
    CGFloat _collectionViewPadding;
    ZYZoomScrollView *_zoomScrollView;
    UIImageView *_currentBrowserImageView;
    CGPoint _currentLocation;
    CGFloat _animationDuration;
}

#pragma mark - Initial

-(instancetype)initWithImageItems:(NSArray *)imageItems {
    self = [super init];
    if (self) {
        _photos = imageItems;
        _collectionViewPadding = 15;
        _animationDuration = 0.3;
        [self browser_addSubViews];
    }
    return self;
}
#pragma mark - Show

-(void)showAnimated:(BOOL)animated {
    [self showAtIndex:0 animated:animated];
}

-(void)showAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(_photos.count > index, @"index 越界");
    self.photoWindow.hidden = NO;
    self.currentItem = _photos[index];
    
    CGFloat x = index * self.iCollectionView.bounds.size.width;
    
    [self.iCollectionView setContentOffset:CGPointMake(x, 0)];
    
    if (animated) {
        [self animatedIn];
    }else{
        [UIView animateWithDuration:_animationDuration animations:^{
            self.photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            self.iCollectionView.alpha = 1;
        }];
    }
}

-(void)animatedIn {
    UIImageView *imageView = [self currentTempImageView];
    CGRect animatedInFrame = [self animatedInFrameForImageView:imageView];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:_animationDuration animations:^{
        imageView.frame = animatedInFrame;
        imageView.center = self.view.center;
        self.photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        self.iCollectionView.alpha = 1;
    }];
}

-(CGRect)animatedInFrameForImageView:(UIImageView *)imageView {
    CGFloat imageWidth = imageView.image.size.width;
    CGFloat imageHeight = imageView.image.size.height;
    CGRect frame = CGRectZero;
    frame.size.width = ZYViewWidth;
    frame.size.height = imageHeight * (ZYViewWidth / imageWidth);
    return frame;
}

#pragma mark - hide

-(void)hideAnimated:(BOOL)animated {
    if (!_currentBrowserImageView.image || !animated) {
        [self hide];
    }else{
        [self animatedOut];
    }
}
-(void)hide {
    [self showSourceImageView];
    
    [UIView animateWithDuration:_animationDuration animations:^{
        self.photoWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.photoWindow.rootViewController = nil;
    }];
}

-(void)animatedOut {
    UIImageView *browserImageView = _currentBrowserImageView;
    CGRect sourceFrame = [self currentSourceImageViewFrame];
    UIImageView *sourceImageView = [self currentSourceImageView];
    [UIView animateWithDuration:_animationDuration animations:^{
        browserImageView.frame = sourceFrame;
        self.photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        self.photoWindow.hidden = YES;
        sourceImageView.alpha = 1;
        self.photoWindow.rootViewController = nil;
    }];
}

-(void)browser_addSubViews {
    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    [self.view addGestureRecognizer:self.singleTapGesture];
    [self.view addGestureRecognizer:self.doubleTapGesture];
    [self.view addGestureRecognizer:self.panGesture];
    [self.view addGestureRecognizer:self.longPressGesture];
    [self.view addSubview:self.iCollectionView];
}

-(UIImageView *)currentSourceImageView {
    return self.currentItem.sourceImageView;
}

-(UIImageView *)currentTempImageView {
    CGRect convertRect = [self currentSourceImageViewFrame];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = self.currentItem.sourceImageView.image;
    imageView.frame = convertRect;
    return imageView;
}

-(CGRect)currentSourceImageViewFrame {
    ZYImageItem *item = self.currentItem;
    CGRect convertRect = [item.sourceImageView.superview convertRect:item.sourceImageView.frame toView:self.view];
    return convertRect;
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZYImageCell" forIndexPath:indexPath];
    cell.item = _photos[indexPath.row];
    _zoomScrollView = cell.zoomView;
    _currentBrowserImageView = _zoomScrollView.imageView;
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - _collectionViewPadding, ZYScreenHeight);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self configueCurrentZoomViewAtIndex:index];
    if (_photos.count > index) {
        self.currentItem = _photos[index];
    }
}

-(void)configueCurrentZoomViewAtIndex:(NSInteger)index {
    index = index ?: 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ZYImageCell *cell = (ZYImageCell *)[self.iCollectionView cellForItemAtIndexPath:indexPath];
    _zoomScrollView = cell.zoomView;
    _currentBrowserImageView = _zoomScrollView.imageView;
}

#pragma mark - Setter

-(void)setCurrentItem:(ZYImageItem *)currentItem {
    if (_currentItem) {
        _currentItem.sourceImageView.alpha = 1.0;
    }
    _currentItem = currentItem;
    _currentItem.sourceImageView.alpha = 0.0;
}

#pragma mark - Getter
-(UIWindow *)photoWindow {
    if (!_photoWindow) {
        _photoWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _photoWindow.windowLevel = UIWindowLevelAlert;
        _photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _photoWindow.rootViewController = self;
        [_photoWindow makeKeyAndVisible];
    }
    return _photoWindow;
}

-(UICollectionView *)iCollectionView {
    if (!_iCollectionView) {
        CGRect frame = CGRectMake(0, 0, ZYScreenWidth + _collectionViewPadding, ZYScreenHeight);
        _iCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:self.iFlowLayout];
        _iCollectionView.backgroundColor = [UIColor clearColor];
        _iCollectionView.alpha = 0;
        _iCollectionView.delegate = self;
        _iCollectionView.dataSource = self;
        _iCollectionView.multipleTouchEnabled = YES;
        _iCollectionView.pagingEnabled = YES;
        _iCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        _iCollectionView.showsVerticalScrollIndicator = NO;
        _iCollectionView.showsHorizontalScrollIndicator = NO;
        [_iCollectionView registerClass:[ZYImageCell class] forCellWithReuseIdentifier:@"ZYImageCell"];
    }
    return _iCollectionView;
}

-(UICollectionViewFlowLayout *)iFlowLayout {
    if (!_iFlowLayout) {
        _iFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _iFlowLayout.minimumLineSpacing = _collectionViewPadding;
        _iFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _iFlowLayout.minimumInteritemSpacing = 0;
    }
    return _iFlowLayout;
}

-(UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(responsePanGesture:)];
    }
    return _panGesture;
}

-(UITapGestureRecognizer *)singleTapGesture {
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(responseSingleTapGesture:)];
        _singleTapGesture.numberOfTapsRequired = 1;
    }
    return _singleTapGesture;
}

-(UITapGestureRecognizer *)doubleTapGesture {
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(responseDoubleTapGesture:)];
        _doubleTapGesture.numberOfTapsRequired = 2;
    }
    return _doubleTapGesture;
}
-(UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(responseLongPressGesture:)];
    }
    return _longPressGesture;
}

#pragma mark - Gesture
-(void)responsePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    _currentLocation = location;
    
    CGPoint velocity = [pan velocityInView:self.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self translationAndScaleImageWith:translation];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            double offsetY = fabs(translation.y);
            double velocityY = fabs(velocity.y);
            
            if ( offsetY > 100 || velocityY > 500) {
                [self hideAnimated:YES];
            }else{
                [self cancelGestureRecognizerAnimation];
            }
        }
            break;
        default:
            break;
    }
}

-(void)showSourceImageView {
    UIImageView *sourceImageView = [self currentSourceImageView];
    sourceImageView.alpha = 1;
}

-(void)translationAndScaleImageWith:(CGPoint)point {
    
    if (!_currentBrowserImageView.image) {
        [self showSourceImageView];
    }
    
    double translationY = point.y;
    double translationX = point.x;

    double x = fabs(translationY) / ZYScreenHeight;
    double alpha = 7 * x * x - 8 * x + 1;
    alpha =  MAX(alpha, 0);
    
    double percent = 1 - x;
    percent = MAX(percent, 0);
    double s = MAX(percent, 0.5);
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translationX/s,translationY/s);
    CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
    
    if (_zoomScrollView.zoomScale > 1) {
        [UIView animateWithDuration:0.2 animations:^{
            _zoomScrollView.zoomScale = 1.0;
            _currentBrowserImageView.transform = CGAffineTransformConcat(trans, scale);
        }];
    }else{
        _currentBrowserImageView.transform = CGAffineTransformConcat(trans, scale);

    }

    self.iCollectionView.alpha = MAX(percent, 0.8);
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    _photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
}

- (void)cancelGestureRecognizerAnimation
{
    [UIView animateWithDuration:_animationDuration animations:^{
        _currentBrowserImageView.transform = CGAffineTransformIdentity;
        self.iCollectionView.alpha = 1.0;
        _photoWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
    }];
}


-(void)responseLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(imageBrowser:responseLongPressGestureRecognizer:)]) {
        [self.delegate imageBrowser:self responseLongPressGestureRecognizer:gesture];
    }else{
        if (gesture.state != UIGestureRecognizerStateBegan) {
            return;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存当前图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)responseSingleTapGesture:(UIPanGestureRecognizer *)gesture {
    if (_zoomScrollView.zoomScale == 1.0) {
        [self hideAnimated:YES];
    }else {
        
    }
}

-(void)responseDoubleTapGesture:(UIPanGestureRecognizer *)gesture {
    
    if (_zoomScrollView.zoomScale > 1.0) {
        [_zoomScrollView setZoomScale:1.0 animated:YES];
    }else {
        CGPoint location = [gesture locationInView:self.view];
        
        CGFloat maxZoomScale = _zoomScrollView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;

        [_zoomScrollView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}


-(void)dealloc {
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
}




@end
