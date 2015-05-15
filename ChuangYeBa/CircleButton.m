//
//  CircleButton.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCircleImage:(UIImage *)image placeholder:(UIImage *)placeholder forState:(UIControlState)state {
    if (image) {
        [super setImage:[self circleImage:image withParam:0.0] forState:state];
    } else {
        [super setImage:[self circleImage:placeholder withParam:0.0] forState:state];
    }
}

// 裁剪头像图片为圆形
- (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    //CGContextAddEllipseInRect(context, rect);
    //CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


@end
