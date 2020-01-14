//
//  TestCell.m
//  NutPoolDemo
//
//  Created by John Shu on 2020/1/14.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import "TestCell.h"
#import <objc/runtime.h>
#import "TestProducer.h"

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static char * key = "cellTaskKey";

- (NutTask *)task {
    return objc_getAssociatedObject(self, key);
}

- (void)setTask:(NutTask *)task {
    objc_setAssociatedObject(self, key, task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fetchProductFromPool:(NutPool *)pool {
    NutTask *originTask = [self task];
    [originTask cancel];
    
    __weak __typeof(self)weakSelf = self;
    NutTask *task = [pool productTask:^(StringProduct *product, NSError *error) {
        weakSelf.textLabel.text = product.name;
    }];
    
    [self setTask:task];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.text = @"loading...";
}
@end
