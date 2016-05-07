//
//  ViewController.m
//  NSOperation_MergedImagesFromInternet
//
//  Created by  江苏 on 16/5/7.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property(nonatomic,strong)UIImage* image1;

@property(nonatomic,strong)UIImage* image2;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建队列
    NSOperationQueue* queue=[[NSOperationQueue alloc]init];
    
    //创建行为
    NSBlockOperation* blockOp1=[NSBlockOperation blockOperationWithBlock:^{
        
        NSURL* url=[NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/h%3D200/sign=5dd4abde3f6d55fbdac671265d224f40/a044ad345982b2b7abe1fec433adcbef76099bb0.jpg"];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        self.image1=[UIImage imageWithData:data];
        
    }];
    
    NSBlockOperation* blockOp2=[NSBlockOperation blockOperationWithBlock:^{
        
        NSURL* url=[NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/h%3D200/sign=52e860e6932397ddc9799f046983b216/dc54564e9258d109840ef0b3d358ccbf6d814dc5.jpg"];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        self.image2=[UIImage imageWithData:data];
        
    }];
    
    NSBlockOperation* blockOp3=[NSBlockOperation blockOperationWithBlock:^{
        
        UIGraphicsBeginImageContext(CGSizeMake(320, 568));
        
        [self.image1 drawInRect:CGRectMake(0, 0, 320, 200)];
        
        [self.image2 drawInRect:CGRectMake(0, 200, 320, 369)];
        
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        
        //渲染完成后，回到主界面更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image=image;
        }];
    }];
    
    //设置依赖关系
    [blockOp3 addDependency:blockOp1];
    [blockOp3 addDependency:blockOp2];
    
    //加入队列，自动执行异步并发和依赖关系
    [queue addOperation:blockOp1];
    [queue addOperation:blockOp2];
    [queue addOperation:blockOp3];
    
}

@end
