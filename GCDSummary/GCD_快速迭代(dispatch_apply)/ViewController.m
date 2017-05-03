//
//  ViewController.m
//  GCD_快速迭代(dispatch_apply)
//
//  Created by chen on 2017/4/29.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveFileWithGcdApply];
}

-(void)forDemo{
    
    //for 循环是同步的，不是异步的
    for (NSInteger i=0; i<10; i++) {
        NSLog(@"%zd  %@",i,[NSThread currentThread]);
    }
    
    /*
     number = 1，name= main 是主线程
     
     2017-04-29 06:01:24.894 GCD_快速迭代(dispatch_apply)[4608:16982314] 0  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.894 GCD_快速迭代(dispatch_apply)[4608:16982314] 1  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 2  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 3  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 4  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 5  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 6  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.895 GCD_快速迭代(dispatch_apply)[4608:16982314] 7  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.896 GCD_快速迭代(dispatch_apply)[4608:16982314] 8  <NSThread: 0x600000066e40>{number = 1, name = main}
     2017-04-29 06:01:24.896 GCD_快速迭代(dispatch_apply)[4608:16982314] 9  <NSThread: 0x600000066e40>{number = 1, name = main}
     */
    
    
}


/*
 日志
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17001661] 索引 = 0, 线程=<NSThread: 0x600000262bc0>{number = 1, name = main}
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17001727] 索引 = 1, 线程=<NSThread: 0x600000267a40>{number = 3, name = (null)}
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17001724] 索引 = 3, 线程=<NSThread: 0x60000026af00>{number = 5, name = (null)}
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17002027] 索引 = 2, 线程=<NSThread: 0x60800026b3c0>{number = 4, name = (null)}
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17001661] 索引 = 4, 线程=<NSThread: 0x600000262bc0>{number = 1, name = main}
 2017-04-29 06:10:35.479 GCD_快速迭代(dispatch_apply)[4708:17001727] 索引 = 5, 线程=<NSThread: 0x600000267a40>{number = 3, name = (null)}
 */
#pragma mark -- gcdapply demo
-(void)dispatchOfApply
{
    dispatch_queue_t queue = dispatch_queue_create("com.apply.demo", DISPATCH_QUEUE_CONCURRENT);
    //使用dispatch_apply函数能进行快速迭代遍历
    //参数1:遍历的次数
    //参数2:队列，必须是并发队列
    //参数3:index 索引
    dispatch_apply(10, queue, ^(size_t index) {
        
        NSLog(@"索引 = %zd, 线程=%@",index,[NSThread currentThread]);
    });
    

    
}

#pragma mark -- 文件从一个文件夹剪接到另一个文件夹
-(void)movefile
{
    //1拿到来源文件的路径
    NSString *sourcePath = @"/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/from";
    //2 获得目标文件路径
    NSString *desinationPath = @"/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/to";
    //3 得到来源目录下的所有文件
    NSArray *subPath = [[NSFileManager defaultManager] subpathsAtPath:sourcePath];
    //4 遍历所有文件，然后执行剪切操作
    NSInteger fileCount = [subPath count];
    
    
    for (int i = 0; i < fileCount; i++) {
        
        //获取每个文件的子路径
        NSString *subItemFilePath = [subPath objectAtIndex:i];
        //4.1 拼接文件的全路径
        NSString *fromFullPath = [sourcePath stringByAppendingPathComponent:subItemFilePath];
        NSString *toFullPath = [desinationPath stringByAppendingPathComponent:subItemFilePath];
        
        NSError *error = nil;
        
        
        //4.2 执行剪切操作
        BOOL bMoveFile = [[NSFileManager defaultManager] moveItemAtPath:fromFullPath toPath:toFullPath error:&error];
        
        if (bMoveFile) {
            NSLog(@"move file success");
            NSLog(@"%@---%@--%@",fromFullPath,toFullPath,[NSThread currentThread]);

        }
        else{
            
            if (error) {
                NSLog(@"move failed:%@", [error localizedDescription]);
            }
            
        }
        
    }
    
    
    
    
}

#pragma mark -- 文件从一个文件夹剪接到另一个文件夹

/*
 2017-04-30 06:32:18.323 GCD_快速迭代(dispatch_apply)[9880:17348207] /workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/from/intro_movie_1@2x.png---/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/to/intro_movie_1@2x.png--<NSThread: 0x608000269140>{number = 3, name = (null)}
 2017-04-30 06:32:18.323 GCD_快速迭代(dispatch_apply)[9880:17348713] /workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/from/intro_movie_4@2x.png---/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/to/intro_movie_4@2x.png--<NSThread: 0x6080002695c0>{number = 5, name = (null)}
 2017-04-30 06:32:20.751 GCD_快速迭代(dispatch_apply)[9880:17348156] move file success
 2017-04-30 06:32:20.751 GCD_快速迭代(dispatch_apply)[9880:17348156] /workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/from/intro_movie_5@2x.png---/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/to/intro_movie_5@2x.png--<NSThread: 0x60000007ed00>{number = 1, name = main}
 
 */
-(void)moveFileWithGcdApply
{
    //1拿到来源文件的路径
    NSString *sourcePath = @"/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/from";
    //2 获得目标文件路径
    NSString *desinationPath = @"/workSpace/GCDSummary/GCDSummary/GCDSummary/GCD_快速迭代(dispatch_apply)/to";
    //3 得到来源目录下的所有文件
    NSArray *subPath = [[NSFileManager defaultManager] subpathsAtPath:sourcePath];
    //4 遍历所有文件，然后执行剪切操作
    NSInteger fileCount = [subPath count];
    
    dispatch_apply(fileCount, dispatch_get_global_queue(0, 0), ^(size_t i) {
        //获取每个文件的子路径
        NSString *subItemFilePath = [subPath objectAtIndex:i];
        //4.1 拼接文件的全路径
        NSString *fromFullPath = [sourcePath stringByAppendingPathComponent:subItemFilePath];
        NSString *toFullPath = [desinationPath stringByAppendingPathComponent:subItemFilePath];
        NSError *error = nil;
        
        
        //4.2 执行剪切操作
        BOOL bMoveFile = [[NSFileManager defaultManager] moveItemAtPath:fromFullPath toPath:toFullPath error:&error];
        
        if (bMoveFile) {
            NSLog(@"move file success");
            NSLog(@"%@---%@--%@",fromFullPath,toFullPath,[NSThread currentThread]);
            
        }
        else{
            
            if (error) {
                NSLog(@"move failed:%@", [error localizedDescription]);
            }
            
        }

        
        
    });
}

@end
