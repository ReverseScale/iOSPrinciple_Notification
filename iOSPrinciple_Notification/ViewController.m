//
//  ViewController.m
//  iOSPrinciple_Notification
//
//  Created by WhatsXie on 2018/5/15.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSPortDelegate>
{
    NSPort *_port;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSPort
    [self testPortDemo];
    
    // object：指定接受某个对象的通知，为nil表示可以接受任意对象的通知
    // 观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifi:) name:@"EdisonNotif" object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // NSNotification
//    [self sendNotification];
//    [self sendNotificationQueue];
//    [self sendNotificationThread];
//    [self sendAsyncNotification];
//    [self sendAsyncNotificationTwo];
    
    // NSPort
//    [self sendPort];
    [NSThread detachNewThreadSelector:@selector(sendPort) toTarget:self withObject:nil];
}

- (void)sendNotification {
    NSLog(@"发送通知before：%@", [NSThread currentThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EdisonNotif" object:nil];
    NSLog(@"发送通知after：%@", [NSThread currentThread]);
}

- (void)sendNotificationQueue {
    //每个线程都默认又一个通知队列，可以直接获取，也可以alloc
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    NSNotification * notification = [NSNotification notificationWithName:@"EdisonNotif" object:nil];
    
    NSLog(@"异步发送通知before:%@",[NSThread currentThread]);
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    NSLog(@"异步发送通知after:%@",[NSThread currentThread]);
}

- (void)sendNotificationThread {
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    NSNotification * notification = [NSNotification notificationWithName:@"EdisonNotif" object:nil];
    
    NSLog(@"发送通知before：%@", [NSThread currentThread]);
//    [NSThread detachNewThreadSelector:@selector(sendNotification) toTarget:self withObject:nil];
//    [notificationQueue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationNoCoalescing forModes:nil];
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
    NSLog(@"发送通知after：%@", [NSThread currentThread]);
}


- (void)handleNotifi:(NSNotification*)notif {
    NSLog(@"接收到通知了:%@", [NSThread currentThread]);
}

- (void)sendAsyncNotification {
    //每个线程都默认又一个通知队列，可以直接获取，也可以alloc
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    
    NSNotification * notification = [NSNotification notificationWithName:@"EdisonNotif" object:nil];
    
    NSLog(@"异步发送通知before:%@",[NSThread currentThread]);
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
    NSLog(@"异步发送通知after:%@",[NSThread currentThread]);
    
    NSPort * port = [NSPort new];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)sendAsyncNotificationTwo {
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    
    NSNotification * notification = [NSNotification notificationWithName:@"EdisonNotif" object:nil];
    NSNotification * notificationtwo = [NSNotification notificationWithName:@"EdisonNotif" object:nil];
    
    NSLog(@"异步发送通知before:%@",[NSThread currentThread]);
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    [notificationQueue enqueueNotification:notificationtwo postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    NSLog(@"异步发送通知after:%@",[NSThread currentThread]);
    
    NSPort * port = [NSPort new];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)testPortDemo {
    _port  =[[NSPort alloc] init];
    //消息处理通过代理来处理的
    _port.delegate = self;
    //把端口加在哪个线程里，就在哪个线程进行处理，下面：加在当前线程的runloop里
    [[NSRunLoop currentRunLoop] addPort:_port forMode:NSRunLoopCommonModes];
}

//发送消息
- (void)sendPort {
    NSLog(@"port发送通知before:%@",[NSThread currentThread]);
    [_port sendBeforeDate:[NSDate date] msgid:1212 components:nil from:nil reserved:0];
    NSLog(@"port发送通知after:%@",[NSThread currentThread]);
}

//处理消息
- (void)handlePortMessage:(NSPortMessage *)message {
    NSLog(@"port处理任务:%@",[NSThread currentThread]);
    NSObject * messageObj = (NSObject*)message;
    NSLog(@"=%@",[messageObj valueForKey:@"msgid"]);
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
