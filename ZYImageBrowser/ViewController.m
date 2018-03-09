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
    NSString *imageName = [NSString stringWithFormat:@"photo%d.jpg",1];
    
    UIImage *image = [UIImage imageNamed:imageName];

    _imageView = [[UIImageView alloc]initWithImage:image];
    _imageView.frame = CGRectMake(0, 110, 100, 100);
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    [self loadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_imageView addGestureRecognizer:tap];
}

-(void)taped:(UITapGestureRecognizer *)tap {
    ZYImageBrowser *browser = [[ZYImageBrowser alloc] initWithImageItems:_photos];
    [browser showAtIndex:0];
}
-(void)loadData {
    NSMutableArray * photos = [[NSMutableArray alloc]init];
    for (int i = 0; i < 8; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"photo%d.jpg",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        //        [photos addObject:image];
        
        ZYImageItem *item = [[ZYImageItem alloc] initWithImage:image sourceImageView:_imageView];
        [photos addObject:item];
    }
    _photos = photos;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self presentViewController:browser animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
