//
//  ZYImageBrowser.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/2/27.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYImageItem.h"
#import "ZYImageItemManager.h"

@class ZYImageBrowser;
@protocol ZYImageBrowserDelegate<NSObject>

@optional
-(void)imageBrowser:(ZYImageBrowser *)imageBrowser responseLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
@end


@interface ZYImageBrowser : UIViewController

@property(nonatomic,strong)ZYImageItemManager * itemManager;
@property(nonatomic,weak)id<ZYImageBrowserDelegate>delegate;

/**
 使用 item 初始化 ZYImageBrowser

 @param imageItems ZYImageItem对象
 @return self
 */
-(instancetype)initWithImageItems:(NSArray *)imageItems;

/**
 显示

 @param animated 是否显示图片放大的到位置上动画
 */
-(void)showAnimated:(BOOL)animated;

/**
 从index位置的图片开始显示

 @param index 索引
 @param animated 是否显示图片放大的到位置上动画
 */
-(void)showAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 隐藏

 @param animated 是否显示图片回到位置上的动画
 */
-(void)hideAnimated:(BOOL)animated;
@end
