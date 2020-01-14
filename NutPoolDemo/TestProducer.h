//
//  TestProducer.h
//  NutPoolDemo
//
//  Created by John Shu on 2020/1/14.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NutPoolOC/NutPool.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringProduct : NSObject <NutProduct>
@property(nonatomic, strong) NSString *name;
@end

@interface TestProducer : NSObject <NutProducer>

@end

NS_ASSUME_NONNULL_END
