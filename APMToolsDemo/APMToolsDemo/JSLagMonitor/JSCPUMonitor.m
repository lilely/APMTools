//
//  JSCPUMonitor.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/6.
//  Copyright © 2020 星金. All rights reserved.
//

#import "JSCPUMonitor.h"
#include <mach/mach.h>

@implementation JSCPUMonitor

+ (void)detectCPUUsage {
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0;i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info(threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount)) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                NSLog(@"CPU usage of this thread:%d",cpuUsage);
            } else {
                NSLog(@"hahaha");
            }
        }
    }
}

@end
