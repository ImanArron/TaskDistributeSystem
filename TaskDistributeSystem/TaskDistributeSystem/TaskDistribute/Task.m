//
//  Task.m
//  TaskDistributeSystem
//
//  Created by LiiuLian on 2018/5/17.
//  Copyright © 2018年 LiuLian. All rights reserved.
//

#import "Task.h"

@interface Task ()

// 任务id
@property (nonatomic, copy) NSString *taskId;

@end

@implementation Task

- (instancetype)initWithTaskId:(NSString *)taskId {
    self = [super init];
    if (self) {
        self.taskId = taskId;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"taskId-%@, weight-%i, resendTimes-%i, isExecuting-%@, isCanceled-%@", self.taskId, self.weight, self.resendTimes, self.isExecuting?@"YES":@"NO", self.isCanceled?@"YES":@"NO"];
}

@end
