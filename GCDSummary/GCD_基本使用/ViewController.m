//
//  ViewController.m
//  GCD_基本使用
//
//  Created by chen on 2017/5/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *p = [[Person alloc] init];
    Person *p1 = [[Person alloc] init];
    
    NSLog(@"p = %@ p1 = %@",p.arrayPerson,p1.arrayPerson);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    //[self gcdWithTimer];
}

-(void)gcdWithTimer
{
    //1 延迟执行的第1种方法
    //[self performSelector:@selector(delay) withObject:nil afterDelay:2.0];
    
    //2 延迟执行的第2种方法
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delay) userInfo:nil repeats:YES];
    
    //3 延迟执行的第3种方法
    dispatch_queue_t queue = dispatch_get_main_queue();
    //dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //参数1 DISPATCH_TIME_NOW从现在开始计算时间
    //参数2 延迟的时间 2.0 GCD的时间单位：纳秒
    //参数3 队列
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"GCD after---%@",[NSThread currentThread]);
    });
}

#pragma mark -- 延迟执行
-(void)delay
{
    NSLog(@"task 延迟执行---%@",[NSThread currentThread]);
    
}

#pragma mark -- 一次性代码，单例模式
//不能放在懒加载中，应用场景--单例模式
-(void)once
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"执行一次");
    });
    
    
}
@end
