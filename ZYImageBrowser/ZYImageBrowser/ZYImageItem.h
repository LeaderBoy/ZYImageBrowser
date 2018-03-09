//
//  ZYImageItem.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/5.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYImageItem : NSObject
@property(nonatomic,strong,readonly)NSURL *url;
@property(nonatomic,strong,readonly)NSURL *thumbImageURL;
@property(nonatomic,strong,readonly)UIImage *image;
@property(nonatomic,strong,readonly)UIImageView *sourceImageView;

/**
 使用本地图片 初始化item

 @param image 图片
 @param sourceImageView 点击的imageView
 @return self
 */
-(instancetype)initWithImage:(UIImage *)image sourceImageView:(UIImageView *)sourceImageView;

/**
 使用网络图片地址 初始化item

 @param url 图片的地址
 @param sourceImageView 点击的ImageView
 @return self
 */
-(instancetype)initWithURL:(NSURL *)url sourceImageView:(UIImageView *)sourceImageView;

/**
 使用网络图片和缩略图 初始化item

 @param url 图片的url
 @param thumbImageURL 缩略图的url
 @param sourceImageView 点击的imageView
 @return self
 */
-(instancetype)initWithURL:(NSURL *)url thumbImageURL:(NSURL *)thumbImageURL sourceImageView:(UIImageView *)sourceImageView;


@end
