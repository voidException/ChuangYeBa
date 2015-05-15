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
    self.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    // 绘制底部边缘线
    [[UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    UIRectFrame(frame);
    
    // 绘制斜杠
    CGPoint startPoint =  CGPointMake(self.frame.size.width - 35, 25);
    CGPoint endPoint = CGPointMake(self.frame.size.width - 38, 36);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    [[UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

@end
