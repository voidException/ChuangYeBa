//
//  CustomSegueUnwind.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CustomSegueUnwind.h"

@implementation CustomSegueUnwind

- (void)perform {
    UIViewController *secondVC = self.sourceViewController;
    UIViewController *firstVC = self.destinationViewController;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    firstVC.view.frame = CGRectMake( - screenWidth, 0, screenWidth, screenHeight);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:firstVC.view aboveSubview:secondVC.view];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        firstVC.view.frame = CGRectOffset(firstVC.view.frame,  screenWidth, 0.0);
        secondVC.view.frame = CGRectOffset(secondVC.view.frame,  screenWidth, 0.0);
    } completion:^(BOOL finished) {
        [self.sourceViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    
}


@end
