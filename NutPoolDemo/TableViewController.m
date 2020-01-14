//
//  TableViewController.m
//  NutPoolDemo
//
//  Created by John Shu on 2020/1/14.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import "TableViewController.h"
#import "TestProducer.h"
#import "TestCell.h"
#import <NutPoolOC/NutPool.h>

@interface TableViewController ()

@property(nonatomic, strong) TestProducer *producer;
@property(nonatomic, strong) NutPool *nutPool;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.producer = [[TestProducer alloc] init];
    self.nutPool = [[NutPool alloc] initWithProducer:self.producer poolCount:10];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell fetchProductFromPool:self.nutPool];
    return cell;
}

@end
