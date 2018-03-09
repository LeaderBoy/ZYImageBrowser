//
//  ZYImageItem.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/5.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYImageItem.h"
@interface ZYImageItem()
@property(nonatomic,strong,readwrite)NSURL *url;
@property(nonatomic,strong,readwrite)NSURL *thumbImageURL;
@property(nonatomic,strong,readwrite)UIImage *image;
@property(nonatomic,strong,readwrite)UIImageView *sourceImageView;
@end

@implementation ZYImageItem
-(instancetype)initWithURL:(NSURL *)url sourceImageView:(UIImageView *)sourceImageView {
    self = [super init];
    if (self) {
        _url = url;
        _sourceImageView = sourceImageView;
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image sourceImageView:(UIImageView *)sourceImageView {
    self = [super init];
    if (self) {
        _image = image;
        _sourceImageView = sourceImageView;
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url thumbImageURL:(NSURL *)thumbImageURL sourceImageView:(UIImageView *)sourceImageView {
    self = [super init];
    if (self) {
        _url = url;
        _thumbImageURL = thumbImageURL;
        _sourceImageView = sourceImageView;
    }
    return self;
}
@end
