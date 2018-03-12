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

@property(nonatomic,assign)SDWebImageOptions webImageOptions;
@property(nonatomic,assign)ZYImageBrowserLoadingStyle loadingStyle;

+(instancetype)sharedItemManager;
@end
