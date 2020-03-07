//
//  JSFPSMonitor.m
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/7.
//  Copyright © 2020 星金. All rights reserved.
//

#import "JSFPSMonitor.h"
#import <UIKit/UIKit.h>

@interface JSFPSMonitor(){
    CADisplayLink *_displayLink;
    CFTimeInterval _lastTimeStamp;
}

@end

@implementation JSFPSMonitor

static int fpsCount = 0;

+ (instancetype)sharedInstance {
    static JSFPSMonitor *_instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)startMonitor {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(monitorLink:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = displayLink;
}

- (void)endMonitor {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)monitorLink:(CADisplayLink *)displayLink {
    if (_lastTimeStamp == 0) {
        _lastTimeStamp = displayLink.timestamp;
    }
    fpsCount ++;
    if (displayLink.timestamp - _lastTimeStamp < 1.0) {
        return;
    }
    _lastTimeStamp = displayLink.timestamp;
    int fps = fpsCount;
    NSLog(@"fps is %d",fps);
    fpsCount = 0;
}

@end
