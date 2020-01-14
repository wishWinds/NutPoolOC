//
//  TestProducer.m
//  NutPoolDemo
//
//  Created by John Shu on 2020/1/14.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import "TestProducer.h"

@implementation StringProduct

@end

@interface TestProducer ()
@property(nonatomic, strong) NSOperationQueue *queue;
@end

@implementation TestProducer
- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }

    return self;
}


- (void)produceProduct:(NutProductCallback)callback {
    static NSInteger count = 0;

    [self.queue addOperationWithBlock:^{
        sleep(1);
        StringProduct *product = [[StringProduct alloc] init];
        product.name = [@(count++) stringValue];
        callback(product, nil);
    }];

}

@end
