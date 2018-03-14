//
//  ZYImageCell.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/5.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYImageCell.h"
// View
#import "ZYZoomScrollView.h"
@interface ZYImageCell()
@end
@implementation ZYImageCell

-(instancetype)init {
    if (self = [super init]) {
        [self cell_addSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self cell_addSubViews];
    }
    return self;
}

-(void)cell_addSubViews {
    if (!self.zoomView.superview) {
        self.zoomView = [[ZYZoomScrollView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.zoomView];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.zoomView.frame = [self frameForZoomView];
}

-(CGRect)frameForZoomView {
    CGRect frame = self.contentView.bounds;
    return frame;
}

-(void)setItem:(ZYImageItem *)item {
    _item = item;
    self.zoomView.item = item;
}


@end
