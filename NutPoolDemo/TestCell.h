//
//  TestCell.h
//  NutPoolDemo
//
//  Created by John Shu on 2020/1/14.
//  Copyright © 2020 shupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NutPoolOC/NutPool.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestCell : UITableViewCell
- (void)fetchProductFromPool:(NutPool *)pool;

@end

NS_ASSUME_NONNULL_END
