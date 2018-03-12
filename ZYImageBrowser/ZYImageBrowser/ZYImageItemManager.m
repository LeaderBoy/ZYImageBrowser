//
//  ZYImageItemManager.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/3/9.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ZYImageItemManager.h"

@implementation ZYImageItemManager

+(instancetype)sharedItemManager {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

@end
