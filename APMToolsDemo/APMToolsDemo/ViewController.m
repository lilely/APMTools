//
//  ViewController.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/5.
//  Copyright © 2020 星金. All rights reserved.
//

#import "ViewController.h"
#import "JSCPUMonitor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            int a = 100*1000;
        }
    });
    [JSCPUMonitor detectCPUUsage];
}


@end
