//
//  LineNavigationBar.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "LineNavigationBar.h"

@implementation LineNavigationBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}


@end
