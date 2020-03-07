//
//  ViewController.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/5.
//  Copyright © 2020 星金. All rights reserved.
//

#import "ViewController.h"
#import "JSCPUMonitor.h"
#import "JSFPSMonitor.h"
#import "JSMemoryMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JSCPUMonitor detectCPUUsage];
    [JSMemoryMonitor detectMemoryUsage];
    //[JSFPSMonitor.sharedInstance startMonitor];
}


@end
