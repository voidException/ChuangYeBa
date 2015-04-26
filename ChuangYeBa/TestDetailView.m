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
    CGPoint startPoint =  CGPointMake(22, 220);
    CGPoint endPoint = CGPointMake(self.frame.size.width - 22, 220);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}


@end
