//
//  ViewController.m
//  TaskDistributeSystem
//
//  Created by UP-LiuL on 2018/5/18.
//  Copyright © 2018年 LiuLian. All rights reserved.
//

#import "ViewController.h"
#import "TaskManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *maxConcurrencyTaskCountTF;
@property (weak, nonatomic) IBOutlet UITextField *maxResendTimesTF;
@property (strong, nonatomic) NSMutableArray *tasks;
@property (nonatomic, assign) int clickCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = @[].mutableCopy;
    }
    return _tasks;
}

- (IBAction)sendTask:(id)sender {
    if (_maxConcurrencyTaskCountTF.text.intValue > 0) {
        [[TaskManager sharedTaskManager] setMaxConcurrencyTaskCount:_maxConcurrencyTaskCountTF.text.intValue];
    }
    if (_maxResendTimesTF.text.intValue > 0) {
        [[TaskManager sharedTaskManager] setMaxResendTimes:_maxResendTimesTF.text.intValue];
    }
    [self.tasks removeAllObjects];
    for (int i = 0; i < 3; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            Task *task = [[Task alloc] initWithTaskId:[NSString stringWithFormat:@"%i", i]];
            task.weight = (arc4random() % 10) + 1;
            [[TaskManager sharedTaskManager] sendTask:task];
            [self.tasks addObject:task];
        });
    }
}

- (IBAction)removeTask:(id)sender {
    if (self.tasks.count > 0) {
        [[TaskManager sharedTaskManager] removeTask:self.tasks[0]];
    }
}

@end
