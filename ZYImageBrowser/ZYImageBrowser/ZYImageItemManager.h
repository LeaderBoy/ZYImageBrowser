//
//  ZYImageItemManager.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/9.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImageView+WebCache.h>

typedef NS_ENUM(NSUInteger, ZYImageBrowserLoadingStyle) {
    ZYImageBrowserLoadingStyleIndicatorWhite,
    ZYImageBrowserLoadingStyleProgressive,
};
@interface ZYImageItemManager : NSObject


/**
 默认为SDWebImageProgressiveDownload
 */
@property(nonatomic,assign)SDWebImageOptions webImageOptions;

/**
 加载样式默认为 ZYImageBrowserLoadingStyleIndicatorWhite
 */
@property(nonatomic,assign)ZYImageBrowserLoadingStyle loadingStyle;
/**
 是否支持gif 默认为 NO
 */
@property(nonatomic,assign)BOOL enableGIF;


+(instancetype)sharedItemManager;
@end
