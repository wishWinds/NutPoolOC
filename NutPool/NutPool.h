//
//  NutPool.h
//  NutPool
//
//  Created by John Shu on 2020/1/13.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 商品
@protocol NutProduct <NSObject>
@end

/// 消费者
@protocol NutConsumer <NSObject>
@end

/// 生产者
typedef void (^NutProductCallback)(id <NutProduct> product, NSError *error);// 商品生产回调

/// 生产者协议
@protocol NutProducer <NSObject>
- (void)produceProduct:(NutProductCallback)callback;
@end

@interface NutTask : NSBlockOperation
@property(nonatomic, strong) NSString *taskName;
@end


@interface NutPool : NSObject
@property(nonatomic, strong) id <NutProducer> producer;
@property(nonatomic, assign) NSInteger poolCount;
@property(nonatomic, assign) NSInteger maxRetryCount; // max retry times. default 3

- (NutPool *)initWithProducer:(id <NutProducer>)producer poolCount:(NSInteger)poolCount;

- (NutTask *)productTask:(NutProductCallback)callback;
@end
