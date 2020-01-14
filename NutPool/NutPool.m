//
//  NutPool.m
//  NutPool
//
//  Created by John Shu on 2020/1/13.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import "NutPool.h"

@implementation NutTask

@end


@interface NutPool ()
// 生产者
@property(nonatomic, strong) dispatch_queue_t produceQueue;// 生产任务执行队列（线程,worker）
@property(nonatomic, strong) dispatch_semaphore_t produceSemaphore; // 可生产信号

// 消费者
@property(nonatomic, strong) NSOperationQueue *consumeQueue; // 消费任务执行队列（线程,worker）
@property(nonatomic, strong) NSMutableArray<NutTask *> *pendingList;// 正在等待的消费者列表
@property(nonatomic, strong) dispatch_semaphore_t consumeSemaphore;// 可消费信号

// 商品
@property(nonatomic, strong) NSMutableArray *productList; // 商品列表
@property(nonatomic, strong) NSLock *productLock; // 商品列表操作锁

@property(nonatomic, assign) NSInteger currentRetryCount;
@end

void syncMain(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@implementation NutPool

- (NutPool *)initWithProducer:(id <NutProducer>)producer poolCount:(NSInteger)poolCount {
    static NSInteger counter = 0;

    self = [super init];
    if (self) {
        self.maxRetryCount = 3;

        self.producer = producer;
        self.poolCount = poolCount;

        self.produceQueue = dispatch_queue_create([[NSString stringWithFormat:@"nut_pool_produce_queue %@", @(counter)] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        self.produceSemaphore = dispatch_semaphore_create(0);

        self.consumeQueue = [[NSOperationQueue alloc] init];
        self.consumeQueue.maxConcurrentOperationCount = 1;
        self.pendingList = [NSMutableArray array];
        self.consumeSemaphore = dispatch_semaphore_create(poolCount);

        self.productList = [NSMutableArray array];
        self.productLock = [[NSLock alloc] init];

        [self start];
    }

    return self;
}

- (NutTask *)productTask:(NutProductCallback)callback {
    __block NutTask *task;
    syncMain(^{
        NutTask *task = [self productTaskOperation:callback];
        [self.pendingList addObject:task];
        [self.consumeQueue addOperation:task];
    });

    return task;
}

- (NutTask *)productTaskOperation:(NutProductCallback)callback {
    NutTask *taskOperation = [[NutTask alloc] init];
    taskOperation.taskName = [[NSUUID UUID] UUIDString];
    
    [taskOperation addExecutionBlock:^{
        dispatch_semaphore_wait(self.consumeSemaphore, DISPATCH_TIME_FOREVER);

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([taskOperation isCancelled] && taskOperation.isFinished == false) {
                dispatch_semaphore_signal(self.consumeSemaphore);
            } else {
                [self.productLock lock];
                id <NutProduct> product = self.productList.firstObject;
                [self.productList removeObjectAtIndex:0];
                [self.productLock unlock];

                callback(product, nil);
                dispatch_semaphore_signal(self.produceSemaphore);
            }
        });
    }];

    return taskOperation;
}

- (void)cancelProductTask:(NutTask *)task {
    // 任务的状态：正在被添加->已添加(等待商品)->正在派发商品->商品派发完毕完毕
    syncMain(^{
        [task cancel];
        [self.pendingList removeObject:task];
    });
}

- (void)start {
    dispatch_async(self.produceQueue, ^{
        while (true) {
            dispatch_semaphore_wait(self.produceSemaphore, DISPATCH_TIME_FOREVER);

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self.producer produceProduct:^(id <NutProduct> product, NSError *error) {
                    if (error) {
                        NSLog(@"[NutPool] produce product failed: %@", [error localizedDescription]);

                        self.currentRetryCount++;
                        if (self.currentRetryCount < self.maxRetryCount) {
                            dispatch_semaphore_signal(self.produceSemaphore);
                        }
                    } else {
                        [self.productLock lock];
                        [self.productList addObject:product];
                        dispatch_semaphore_signal(self.consumeSemaphore);
                        [self.productLock unlock];
                    }
                }];
            });
        }
    });
}
@end
