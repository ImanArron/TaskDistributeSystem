//
//  TaskManager.h
//  TaskDistributeSystem
//
//  Created by LiiuLian on 2018/5/17.
//  Copyright © 2018年 LiuLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TaskManager : NSObject

// MARK: Init
+ (instancetype)sharedTaskManager;

// MARK: Task
- (void)sendTask:(Task *)task;
- (void)removeTask:(Task *)task;

// MARK: Max
- (void)setMaxConcurrencyTaskCount:(int)count;
- (void)setMaxResendTimes:(int)times;

@end
