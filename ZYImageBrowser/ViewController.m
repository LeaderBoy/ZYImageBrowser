//
//  ViewController.m
//  ZYImageBrowser
//
//  Created by 杨志远 on 2018/2/27.
//  Copyright © 2018年 BaQiWL. All rights reserved.
//

#import "ViewController.h"
#import "ZYImageBrowser.h"
//#import "ZYImageItem.h"
@interface ViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController {
    NSArray *_photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self local];
    [self net];
}

-(void)net {
    NSMutableArray * photos = [[NSMutableArray alloc]init];
    
    NSMutableArray *originalURLs = [NSMutableArray array];
    
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjch9vj20j60kdags.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjjexyj20j60nsguu.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjfk07j20j60n0wkc.jpg"];
    
    for (int i = 0; i < 3; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"火影%02d",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i * (100 + 10), 100, 100, 100)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
        [imageView addGestureRecognizer:tap];
        [self.view addSubview:imageView];
        
        ZYImageItem *item = [[ZYImageItem alloc] initWithURL:[NSURL URLWithString:originalURLs[i]] sourceImageView:imageView];
        
        [photos addObject:item];
    }
    _photos = photos;
}


-(void)local {
    NSMutableArray * photos = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"火影%02d",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i * (100 + 10), 100, 100, 100)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
        [imageView addGestureRecognizer:tap];
        [self.view addSubview:imageView];
        
        ZYImageItem *item = [[ZYImageItem alloc] initWithImage:image sourceImageView:imageView];
        [photos addObject:item];
    }
    _photos = photos;
}

-(void)taped:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    ZYImageBrowser *browser = [[ZYImageBrowser alloc] initWithImageItems:_photos];
    [browser showAtIndex:imageView.tag - 100 animated:NO];
}






@end
