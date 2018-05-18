//
//  TaskManager.m
//  TaskDistributeSystem
//
//  Created by LiiuLian on 2018/5/17.
//  Copyright © 2018年 LiuLian. All rights reserved.
//

#import "TaskManager.h"

typedef void(^ExecuteTaskBlock)(BOOL successed);

@interface TaskManager () {
    int maxConcurrencyTaskCount;
    int maxResendTimes;
}

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (atomic, assign) int executingTaskCount;

@end

@implementation TaskManager

// MARK: Init

+ (instancetype)sharedTaskManager {
    static TaskManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initVars];
    }
    return self;
}

- (void)initVars {
    maxConcurrencyTaskCount = 2;
    maxResendTimes = 2;
}

// MARK: Getter

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

// MARK: Task

- (void)sendTask:(Task *)task {
    [self.lock lock];
    if (task) {
        [self.tasks addObject:task];
    }
    
    if (self.tasks.count == 0) {
        [self.lock unlock];
        return;
    }
    
    if (self.executingTaskCount < maxResendTimes) {
        Task *toBeSendedTask = [self taskWithMaxWeight];
        BOOL canExecute = toBeSendedTask && !toBeSendedTask.isExecuting;
        if (canExecute) {
            self.executingTaskCount += 1;
            toBeSendedTask.isExecuting = YES;
            [self executeTask:toBeSendedTask completed:^(BOOL successed) {
                [self.tasks removeObject:toBeSendedTask];
                if (!successed) {
                    if (toBeSendedTask.resendTimes <= maxResendTimes && !toBeSendedTask.isCanceled) {
                        toBeSendedTask.weight = 11;
                        toBeSendedTask.resendTimes += 1;
                        [self.tasks addObject:toBeSendedTask];
                    }
                }
            }];
        }
        [self.lock unlock];
        if (canExecute) {
            [self sendTask:nil];
        }
        return;
    }
    [self.lock unlock];
}

- (Task *)taskWithMaxWeight {
    if (self.tasks.count > 0) {
        Task *task = self.tasks[0];
        for (int i = 1; i < self.tasks.count; i++) {
            Task *tmpTask = self.tasks[i];
            if ((!tmpTask.isExecuting && task.isExecuting) ||
                (tmpTask.weight > task.weight && !tmpTask.isExecuting)) {
                task = tmpTask;
            }
        }
        return task;
    }
    return nil;
}

- (void)executeTask:(Task *)task completed:(ExecuteTaskBlock)completed {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Task is executing: %@", task.description);
        sleep(1);
        task.isExecuting = NO;
        self.executingTaskCount -= 1;
        BOOL executeSuccessed = NO;
        if (!task.isCanceled) {
            int rand = arc4random();
            // 1/5的失败概率
            executeSuccessed = (0 != (rand%5));
        }
        NSLog(@"Task %@ execut result: %@", task.description, executeSuccessed?@"Successed":@"Failed");
        if (completed) {
            completed(executeSuccessed);
        }
        if (self.executingTaskCount == 0) {
            [self sendTask:nil];
        }
    });
}

- (void)cancelTask:(Task *)task {
    task.isCanceled = YES;
}

- (void)removeTask:(Task *)task {
    NSLog(@"Task %@ is removed", task.description);
    if (task.isExecuting) {
        [self cancelTask:task];
    }
    [self.lock lock];
    if ([self.tasks containsObject:task]) {
        [self.tasks removeObject:task];
    }
    [self.lock unlock];
}

// MARK: Max

- (void)setMaxConcurrencyTaskCount:(int)count {
    if (count > 0) {
        maxConcurrencyTaskCount = count;
    }
}

- (void)setMaxResendTimes:(int)times {
    if (times > 0) {
        maxResendTimes = times;
    }
}

@end
