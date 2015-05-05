//
//  PushSegueNoAnimation.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "PushSegueNoAnimation.h"

@implementation PushSegueNoAnimation

- (void)perform {
    UIViewController *firstVC = self.sourceViewController;
    UIViewController *secondVC = self.destinationViewController;
    [firstVC.navigationController pushViewController:secondVC animated:NO];
}

@end
