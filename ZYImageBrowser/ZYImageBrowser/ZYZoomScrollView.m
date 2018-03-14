//
//  ZYZoomScrollView.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/2.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYZoomScrollView.h"
#import <UIView+WebCache.h>
#import "ZYImageItemManager.h"
#import "UIView+RoundProgressBar.h"
@interface ZYZoomScrollView()<UIScrollViewDelegate>
@end
@implementation ZYZoomScrollView

#pragma mark - Initial
-(instancetype)init {
    if (self = [super init]) {
        [self initialProperty];
        [self zoom_addSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialProperty];
        [self zoom_addSubViews];
    }
    return self;
}

-(void)initialProperty {
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.multipleTouchEnabled = YES;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 2.0;
    self.minimumZoomScale = 1.0;
    
    if (@available(iOS 11.0,*)) {
        [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [self enableGIF];
}

-(void)enableGIF {
    ZYImageItemManager *itemManager = [ZYImageItemManager sharedItemManager];
    if (itemManager.enableGIF) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
    }else {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
}

-(void)zoom_addSubViews {
    [self addSubview:_imageView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self centerImageView];
}
#pragma mark - Setter

-(void)setItem:(ZYImageItem *)item {
    [self resetProperty];
    if (_item != item) {
        _item = item;
    }
    
    if (_item.url) {
        ZYImageItemManager *itemManager = [ZYImageItemManager sharedItemManager];
        ZYImageBrowserLoadingStyle style = [self applyLoadingStyleWithItemManager:itemManager];
        [_imageView sd_setImageWithURL:_item.url placeholderImage:_item.image options:[self applyWebImageOptionsWithItemManager:itemManager] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (style == ZYImageBrowserLoadingStyleProgressive) {
                [_imageView zy_showProgressBarWithProgress:(CGFloat)receivedSize/expectedSize];
            }
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self resizeImage];
        }];
    }else if (_item.image){
        _imageView.image = _item.image;
    }
    
    [self resizeImage];
}

-(SDWebImageOptions)applyWebImageOptionsWithItemManager:(ZYImageItemManager *)itemManager {
    SDWebImageOptions options;
    if (itemManager.webImageOptions) {
        options = itemManager.webImageOptions;
    }else{
        options = SDWebImageProgressiveDownload;
    }
    return options;
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setZoomScale:1.0 animated:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(ZYImageBrowserLoadingStyle)applyLoadingStyleWithItemManager:(ZYImageItemManager *)itemManager {
    ZYImageBrowserLoadingStyle style;
    if (itemManager.loadingStyle == ZYImageBrowserLoadingStyleProgressive) {
        style = ZYImageBrowserLoadingStyleProgressive;
    }else{
        [_imageView sd_setShowActivityIndicatorView:true];
        [_imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        style = ZYImageBrowserLoadingStyleIndicatorWhite;
    }
    return style;
}


-(void)resetProperty {
    _imageView.image = nil;
    self.zoomScale = 1;
//    self.contentSize = CGSizeZero;
}
-(void)resizeImage {
    if (_imageView.image) {
        _imageView.contentMode = UIViewContentModeScaleToFill;
        BOOL isLandScape = [self isLandScape];
        CGFloat scrollHeight = self.bounds.size.height;
        CGFloat scrollWidth = self.bounds.size.width;
        CGSize imageSize = _imageView.image.size;
        
        
        CGFloat resizedImageWidth;
        CGFloat resizedImageHeight;
        
        if (isLandScape) {
            resizedImageHeight = self.bounds.size.height;
            resizedImageWidth = imageSize.width * (scrollHeight/imageSize.height);
            resizedImageWidth = ceil(resizedImageWidth);
        }else{
            resizedImageWidth = self.bounds.size.width ;
            resizedImageHeight = imageSize.height * (scrollWidth/imageSize.width);
            resizedImageHeight = ceil(resizedImageHeight);
        }
        
        CGRect resizedImageFrame = CGRectMake(0, 0, resizedImageWidth, resizedImageHeight);
        _imageView.frame = resizedImageFrame;
        
        if (resizedImageHeight > scrollHeight) {
            _imageView.center = CGPointMake(scrollWidth/2, resizedImageHeight/2);
        }else{
            _imageView.center = self.center;
        }
    }else{
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.center = self.center;
    }
}
#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)centerImageView {
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat contentWidth = self.contentSize.width;
    
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat contentHeight = self.contentSize.height;
    
    CGFloat centerOffsetX = 0;
    CGFloat centerOffsetY = 0;
    
    if (boundsWidth > contentWidth) {
        centerOffsetX = (boundsWidth - contentWidth)/2;
    }
    if (boundsHeight > contentHeight) {
        centerOffsetY = (boundsHeight - contentHeight)/2;
    }
    _imageView.center = CGPointMake(contentWidth/2 + centerOffsetX, contentHeight/2 + centerOffsetY);
}

-(BOOL)isLandScape {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return UIInterfaceOrientationIsLandscape(orientation);
}


@end
