//
//  JSLagMonitor.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/5.
//  Copyright © 2020 星金. All rights reserved.
//

#import "JSLagMonitor.h"

@interface JSLagMonitor() {
    CFRunLoopObserverRef _runLoopObserver;
    NSInteger _timeoutCount;
    @public
    CFRunLoopActivity activity;
}

@property (nonatomic, strong, readonly) dispatch_semaphore_t dispatchSemaphore;

@end

@implementation JSLagMonitor

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    JSLagMonitor *monitory = (__bridge JSLagMonitor *)info;
    monitory->activity = activity;
    dispatch_semaphore_t semaphore = monitory.dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

+ (instancetype)shareInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JSLagMonitor alloc] init];
    });
    return _instance;
}

- (void)beginMonitor {
    if (_runLoopObserver) {
        return;
    }
    _dispatchSemaphore = dispatch_semaphore_create(0);
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    _runLoopObserver =
    CFRunLoopObserverCreate(kCFAllocatorDefault,
                            kCFRunLoopAllActivities,
                            YES,
                            0,
                            &runLoopObserverCallBack,
                            &context);
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long semaphoreWait =
            dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->_runLoopObserver) {
                    self->_timeoutCount = 0;
                    self->_dispatchSemaphore = 0;
                    self->activity = 0;
                    return;
                }
                if (self->activity == kCFRunLoopAfterWaiting || self->activity == kCFRunLoopBeforeWaiting) {
                    if (++self->_timeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"Lag monitored!");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        //Call Stack
                        NSLog(@"Report call stack:%@",[NSThread callStackSymbols]);
                    });
                }
            }
            self->_timeoutCount = 0;
        }
    });
}

- (void)endMonitory {
    if (!_runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}

@end
