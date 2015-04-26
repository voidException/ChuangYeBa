//
//  TestStateCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestStateCell.h"

@implementation TestStateCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    // 绘制底部边缘线
    [[UIColor grayColor] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    UIRectFrame(frame);
    
    // 绘制斜杠
    CGPoint startPoint =  CGPointMake(self.frame.size.width - 35, 24);
    CGPoint endPoint = CGPointMake(self.frame.size.width - 38, 35);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

@end
