//
//  ViewController.m
//  GCD_实现线程间通信
//
//  Created by chen on 2017/5/4.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,weak) IBOutlet UIImageView *pic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1创建子线程下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        //2确定下载图片的url
        NSURL *picUrl = [NSURL URLWithString:@"http://blog.sunnyxx.com/doge-logo.png"];
        
        //3将下载的图片转换成二进制数据
        NSData *picData = [NSData dataWithContentsOfURL:picUrl];
        
        //4转换成uimage
        UIImage *picImage = [UIImage imageWithData:picData];
        
        
        //5主线程更新ui--同步函数+主队列在子线程下是可以更新ui的不会死锁。
        
        dispatch_sync(dispatch_get_main_queue(), ^{
        self.pic.image = picImage;
        });
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.pic.image = picImage;
//        });
        
        
        
    });
    

}

@end
