//
//  ViewController.m
//  GCDSummary
//
//  Created by chen on 2017/4/28.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property(nonatomic,strong)UIImage *image1;
@property(nonatomic,strong)UIImage *image2;

@property (weak, nonatomic) IBOutlet UIImageView *totalImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [NSThread detachNewThreadSelector:@selector(syncMainQueue) toTarget:self  withObject:NULL];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self syncMainQueue];
    
    
}


/*
 
 同步函数：要求立刻马上执行，如果我没有执行完毕，那么后面的任务也别想执行。
 异步函数：如果我没有执行完毕，那么后面的也可以执行。
 
                并发队列       手动创建的串行队列       主队列
 同步函数sync   不会开启新的线程   不会开启新的线程        死锁
                串行执行任务      串行执行任务
 
                
 异步函数async    开启新的线程     开启新的线程          没有开启新的线程
                 并发执行任务     串行执行任务          串行执行任务
 
 注意
 使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列。-死锁。
 
 
 
 */



#pragma mark --异步函数+并发队列，会开启多个线程来并发（同时）执行多个任务。
-(void)asyncConcurrent
{
    //1 创建并发队列 --自己创建的队列
    dispatch_queue_t queue = dispatch_queue_create("com.downlaod.pic", DISPATCH_QUEUE_CONCURRENT);
    

    
    //2 封装任务，将任务添加到队列中
    
    dispatch_async(queue, ^{
        NSLog(@"download1 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3 pic = %@",[NSThread currentThread]);
    });
    
    
    
    /*
     
     download2 pic = <NSThread: 0x600000079ac0>{number = 4, name = (null)}
     download3 pic = <NSThread: 0x608000265b00>{number = 5, name = (null)}
     download1 pic = <NSThread: 0x60000007e380>{number = 3, name = (null)}
     
     开了3个线程number = 3 number = 4 number = 5 来同时执行多个任务。
   
     
     */
    
}


#pragma mark --异步函数+全局并发队列，会开启多个线程来并发（同时）执行多个任务。
-(void)asyncGlobalConcurrent
{
   
    //1 创建全局并发队列 ---直接拿系统的队列,参数1队列的优先级
    //GCD 开多少个线程是由系统内部决定的，不是有4个任务就开4个线程，有可能开2个线程。有些线程完成任务快，空闲了就可以分配给没完成任务的线程
    //#define DISPATCH_QUEUE_PRIORITY_HIGH 2
    //#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
    //#define DISPATCH_QUEUE_PRIORITY_LOW (-2)
    //#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //2 封装任务，将任务添加到队列中
    
    dispatch_async(queue, ^{
        NSLog(@"download1 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download4 pic = %@",[NSThread currentThread]);
    });
    
    
    /*
     
     download2 pic = <NSThread: 0x600000079ac0>{number = 4, name = (null)}
     download3 pic = <NSThread: 0x608000265b00>{number = 5, name = (null)}
     download1 pic = <NSThread: 0x60000007e380>{number = 3, name = (null)}
     
     开了3个线程number = 3 number = 4 number = 5 来同时执行多个任务。
     
     
     */
    
}


#pragma mark --异步函数+串行队列，会开启1个线程按顺序来执行多个任务。
-(void)asyncSerial
{
    //1 创建串行队列
    dispatch_queue_t queue =  dispatch_queue_create("com.downloadPic.serial", DISPATCH_QUEUE_SERIAL);
    
    //2 封装任务，将任务添加到串行队列里面
    
    dispatch_async(queue, ^{
        NSLog(@"serial downloadPic1 = %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"serial downloadPic2 = %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"serial downloadPic3 = %@", [NSThread currentThread]);
    });
    
    
    /*
     
    
     开了一个线程number=3 来串行执行多个任务
     serial downloadPic1 = <NSThread: 0x6000000727c0>{number = 3, name = (null)}
     serial downloadPic2 = <NSThread: 0x6000000727c0>{number = 3, name = (null)}
     serial downloadPic3 = <NSThread: 0x6000000727c0>{number = 3, name = (null)}
     
     */
    
}

#pragma mark -- 同步函数+并发队列 不会开线程，任务是串行执行的。  在主线程，按次序依次执行任务
-(void)syncConcurrent
{
    //1 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent download pic", DISPATCH_QUEUE_CONCURRENT);
    //2 封装任务，将任务添加到并发队列中
    
    dispatch_sync(queue, ^{
        NSLog(@"download1 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3 pic = %@",[NSThread currentThread]);
    });
    /*
     不开启新线程
     download1 pic = <NSThread: 0x60000007af00>{number = 1, name = main}
     download2 pic = <NSThread: 0x60000007af00>{number = 1, name = main}
     download3 pic = <NSThread: 0x60000007af00>{number = 1, name = main}

     */
    
    
    
}


#pragma mark -- 同步函数+串行队列 不会开线程，，任务是串行执行的。
-(void)syncSerial
{
    //1 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent download pic", DISPATCH_QUEUE_SERIAL);
    //2 封装任务，将任务添加到并发队列中
    
    dispatch_sync(queue, ^{
        NSLog(@"download1 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3 pic = %@",[NSThread currentThread]);
    });
    
    /*
     download1 pic = <NSThread: 0x608000063c80>{number = 1, name = main}
     download2 pic = <NSThread: 0x608000063c80>{number = 1, name = main}
     download3 pic = <NSThread: 0x608000063c80>{number = 1, name = main}

     
     */
    
}

#pragma mark --异步函数+主队列：所有的线程都在主线程中执行，不会开线程。
-(void)asyncMainQueue
{
    
    /*
     使用主队列（跟主线程相关联的队列）
     主队列是GCD自带的一种特殊的串行队列
     
     放在主队列中的任务，都会放到主线程中执行
     
     所有的线程都在主线程中执行，不会开线程
     
     使用dispatch_get_main_queue（）获得主队列
     dispatch_queue_t queue = dispatch_get_main_queue();
     */
    dispatch_queue_t queue = dispatch_get_main_queue();
    
 
        dispatch_async(queue, ^{
            NSLog(@"download1 pic = %@",[NSThread currentThread]);
        });
    
        dispatch_async(queue, ^{
            NSLog(@"download2 pic = %@",[NSThread currentThread]);
        });
        
        dispatch_async(queue, ^{
            NSLog(@"download3 pic = %@",[NSThread currentThread]);
        });
        
        dispatch_async(queue, ^{
            NSLog(@"download4 pic = %@",[NSThread currentThread]);
        });
        
  
}

#pragma mark -- 同步函数+主队列:死锁。
//如果把同步函数+主队列放到子线程来执行，那么所有的任务在主线程中执行，不会死锁。   detachNewThreadSelector用这个函数 [NSThread detachNewThreadSelector:@selector(syncMainQueue) toTarget:self  withObject:NULL];

-(void)syncMainQueue
{
    
    /*
     使用主队列（跟主线程相关联的队列）
     主队列是GCD自带的一种特殊的串行队列
     放在主队列中的任务，都会放到主线程中执行
     使用dispatch_get_main_queue（）获得主队列
     dispatch_queue_t queue = dispatch_get_main_queue();
     
     主队列特点：如果主队列发现当前主线程有任务在执行，那么主队列会暂停调用队列中的任务，直到主线程空闲为止。
     
     同步函数要求立刻马上执行，如果我没有执行完毕，那么后面的任务也别想执行。
     */
    dispatch_queue_t queue = dispatch_get_main_queue();
    
     NSLog(@"-----begin-------");
    dispatch_sync(queue, ^{
        NSLog(@"download1 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3 pic = %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download4 pic = %@",[NSThread currentThread]);
    });
    NSLog(@"-----end-------");

}


-(void)group3{
    
    /*
     1 下载图片1 开子线程
     2 下载图片2 开子线程
     3 合并图片并显示图片 开子线程
     
     */
    
    //1 创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2 创建一个全局并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.pic.download", DISPATCH_QUEUE_SERIAL);
    
    //3异步开启一个线程1下载图片1
    dispatch_group_async(group, queue, ^{
        //1 确定url
        NSURL *urlPic = [NSURL URLWithString:@"http://china.nba.com/media/img/players/head/260x190/2544.png"];
        
        //2 下载二进制数据
        NSData *picData = [NSData dataWithContentsOfURL:urlPic];
        
        //3 转换图片
        UIImage *imagePic = [UIImage imageWithData:picData];
        self.image1 =  imagePic;
        
    });
    
    //4异步开启一个线程1下载图片2
    dispatch_group_async(group, queue, ^{
        //1 确定url
        NSURL *urlPic = [NSURL URLWithString:@"http://china.nba.com/media/img/players/head/260x190/202331.png"];
        
        //2 下载二进制数据
        NSData *picData = [NSData dataWithContentsOfURL:urlPic];
        
        //3 转换图片
        UIImage *imagePic = [UIImage imageWithData:picData];
        self.image2 =  imagePic;
        
    });
    
    //5 合并图片
    dispatch_group_notify(group, queue, ^{
       
        //1创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        //2画图1
        [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
        //3画图2
        [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
        //4根据上下文得到一张图
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        //5关闭上下文
        UIGraphicsEndImageContext();
        //6更新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalImage.image = image;
        });
    });
  
    
}




@end
