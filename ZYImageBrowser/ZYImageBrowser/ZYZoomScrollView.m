//
//  ZYZoomScrollView.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/2.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYZoomScrollView.h"
#import <UIImageView+WebCache.h>
#import <UIView+WebCache.h>
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
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
}

-(void)zoom_addSubViews {
    [self addSubview:_imageView];
}

#pragma mark - Setter

-(void)setItem:(ZYImageItem *)item {
    [self resetProperty];
    if (_item != item) {
        _item = item;
    }
    
    if (_item.image) {
        _imageView.image = _item.image;
    }else if (_item.url){
        [_imageView sd_setShowActivityIndicatorView:true];
        [_imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_imageView sd_setImageWithPreviousCachedImageWithURL:_item.url placeholderImage:_item.image options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self resizeImage];
        }];
    }
    
    [self resizeImage];
}



-(void)resetProperty {
    _imageView.image = nil;
    self.zoomScale = 1;
    self.contentSize = CGSizeZero;
}
-(void)resizeImage {
    if (_imageView.image) {
        _imageView.contentMode = UIViewContentModeScaleToFill;

        CGFloat scrollHeight = self.bounds.size.height;
        CGFloat scrollWidth = self.bounds.size.width;
        CGSize imageSize = _imageView.image.size;
        CGFloat resizedImageWidth = self.bounds.size.width;
        CGFloat resizedImageHeight = imageSize.height * (scrollWidth/imageSize.width);
        CGRect resizedImageFrame = CGRectMake(0, 0, resizedImageWidth, resizedImageHeight);
        _imageView.frame = resizedImageFrame;
        
        self.contentSize = resizedImageFrame.size;
        
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
    
    CGFloat boundsWidth = scrollView.bounds.size.width;
    CGFloat contentWidth = scrollView.contentSize.width;
    
    CGFloat boundsHeight = scrollView.bounds.size.height;
    CGFloat contentHeight = scrollView.contentSize.height;
    
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


@end
