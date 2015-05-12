//
//  PushSegueNoAnimation.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ConditionShowSegue.h"

@implementation ConditionShowSegue

- (void)perform {
    UIViewController *srcVC = self.sourceViewController;
    UIViewController *destVC = self.destinationViewController;
    
    [srcVC addChildViewController:destVC];
    [srcVC.view addSubview:destVC.view];
    destVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(srcVC.view.frame), CGRectGetHeight(srcVC.view.frame));
    [destVC didMoveToParentViewController:srcVC];

}

@end
