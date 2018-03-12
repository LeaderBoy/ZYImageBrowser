//
//  ZYZoomScrollView.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/2.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYImageItem.h"
#import <FLAnimatedImageView+WebCache.h>
@interface ZYZoomScrollView : UIScrollView
@property(nonatomic,strong)ZYImageItem *item;
@property(nonatomic,strong)UIImageView *imageView;
@end
