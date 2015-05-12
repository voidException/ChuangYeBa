//
//  photoImageView.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/9.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImage:(UIImage *)image {
    UIImage *newImage = [self circleImage:image withParam:0.0];
    [super setImage:newImage];
}

// 裁剪头像图片为圆形
- (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset {
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
