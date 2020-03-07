//
//  JSMemoryMonitor.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/7.
//  Copyright © 2020 星金. All rights reserved.
//

#import "JSMemoryMonitor.h"
#import "mach/mach.h"

@implementation JSMemoryMonitor

+ (void)detectMemoryUsage {
    NSLog(@"memory usage: %llu",memoryUsage());
}

uint64_t memoryUsage() {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
    if (result != KERN_SUCCESS) {
        return 0;
    }
    return vmInfo.phys_footprint;
}

- (void)startMonitor{
    
}

- (void)endMonitor {
    
}

@end
