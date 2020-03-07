//
//  JSFPSMonitor.h
//  APMToolsDemo
//
//  Created by 星金 on 2020/3/7.
//  Copyright © 2020 星金. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSFPSMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
