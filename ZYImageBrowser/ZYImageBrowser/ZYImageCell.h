//
//  ZYImageCell.h
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/5.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYImageItem.h"
#import "ZYZoomScrollView.h"
@interface ZYImageCell : UICollectionViewCell
@property(nonatomic,strong)ZYImageItem *item;
@property(nonatomic,strong)ZYZoomScrollView *zoomView;
@end
