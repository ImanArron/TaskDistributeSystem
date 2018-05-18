//
//  Task.h
//  TaskDistributeSystem
//
//  Created by LiiuLian on 2018/5/17.
//  Copyright © 2018年 LiuLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

// 权值
@property (nonatomic, assign) int weight;
// 创建时间
@property (nonatomic, assign) NSTimeInterval createdTime;
// 重发次数
@property (nonatomic, assign) int resendTimes;
// 该任务是否正在执行
@property (nonatomic, assign) BOOL isExecuting;
// 该任务是否被取消
@property (nonatomic, assign) BOOL isCanceled;

- (instancetype)initWithTaskId:(NSString *)taskId;

@end
