//
//  CustomSegue.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void)perform {
    UIViewController *firstVC = self.sourceViewController;
    UIViewController *secondVC = self.destinationViewController;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    secondVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:secondVC.view aboveSubview:firstVC.view];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        firstVC.tabBarController.view.frame = CGRectOffset(firstVC.view.frame, - screenWidth, 0.0);
        secondVC.view.frame = CGRectOffset(secondVC.view.frame, - screenWidth, 0.0);
    } completion:^(BOOL finished) {
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    }];
}

@end
