//
//  TestDetailView.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/26.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestDetailView.h"

@implementation TestDetailView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 绘制灰色分割线
    CGPoint startPoint =  CGPointMake(17, 202);
    CGPoint endPoint = CGPointMake(self.frame.size.width - 17, 202);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    [[UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}


@end
