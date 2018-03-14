//
//  UIView+RoundProgressBar.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/12.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "UIView+RoundProgressBar.h"
#import <objc/runtime.h>

static NSString *const kProgressLabelKey = @"kProgressLabelKey";
static NSString *const kProgressLayerKey = @"kProgressLayerKey";
static NSString *const kProgressKey = @"kProgressKey";
static NSString *const kStrokeEndAnimationKey = @"kStrokeEndAnimationKey";

@interface UIView (RoundProgressBarPrivate)
@property(nonatomic,strong)UILabel *progressLabel;
@property(nonatomic,strong)CAShapeLayer *progressLayer;
@end
@implementation UIView (RoundProgressBarPrivate)

-(void)setProgressLabel:(UILabel *)progressLabel {
    objc_setAssociatedObject(self, &kProgressLabelKey, progressLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UILabel *)progressLabel {
    return (UILabel *)objc_getAssociatedObject(self, &kProgressLabelKey);
}

-(void)setProgressLayer:(CAShapeLayer *)progressLayer {
    objc_setAssociatedObject(self, &kProgressLayerKey, progressLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CAShapeLayer *)progressLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, &kProgressLayerKey);
}

@end


@implementation UIView (RoundProgressBar)


-(void)zy_showProgressBarWithProgress:(CGFloat)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.progressLabel &&!self.progressLayer) {
            [self zy_initialProgressBar];
        }
        self.progressLabel.text = [NSString stringWithFormat:@"%2.f%%",fabs(progress * 100)];
        self.progressLayer.strokeEnd = progress;
        if (progress == 1.0) {
            [self zy_removeSubViews];
        }
    });
}

-(void)zy_initialProgressBar {
    [self zy_addProgressBar];
}


-(void)zy_addProgressBar {
    [self zy_removeSubViews];
    
    self.progressLayer = [self roundAnimatedLayer];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 38, 24)];
    label.center = self.center;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    self.progressLabel = label;
    
    [self addSubview:self.progressLabel];
    [self.layer addSublayer:self.progressLayer];
}
-(void)zy_removeSubViews {
    [self.progressLayer removeFromSuperlayer];
    [self.progressLabel removeFromSuperview];
}

-(CAShapeLayer *)roundAnimatedLayer {
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.fillColor = [UIColor clearColor].CGColor;
    roundLayer.strokeColor = [UIColor whiteColor].CGColor;
    roundLayer.lineWidth = 2;
    roundLayer.strokeStart = 0;
    roundLayer.strokeEnd = 0;
    roundLayer.contentsScale = [UIScreen mainScreen].scale;
    roundLayer.path = [self roundPath].CGPath;
    return roundLayer;
}

-(UIBezierPath *)roundPath {
    CGFloat radius = 20;
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    return roundPath;
}

@end
