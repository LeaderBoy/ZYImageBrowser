//
//  ZYImageBrowser.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/2/27.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYImageItem.h"

@class ZYImageBrowser;
@protocol ZYImageBrowserDelegate<NSObject>
-(void)imageBrowser:(ZYImageBrowser *)imageBrowser responseLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
@end


@interface ZYImageBrowser : UIViewController

@property(nonatomic,weak)id<ZYImageBrowserDelegate>delegate;

/**
 使用 item 初始化 ZYImageBrowser

 @param imageItems ZYImageItem对象
 @return self
 */
-(instancetype)initWithImageItems:(NSArray *)imageItems;

/**
 显示
 */
-(void)show;

/**
 从index位置的图片开始显示

 @param index 索引
 */
-(void)showAtIndex:(NSInteger)index;

/**
 隐藏
 */
-(void)hide;
@end
