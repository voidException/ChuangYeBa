//
//  ClassInfoCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassInfoCell.h"

@implementation ClassInfoCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.photo.layer.masksToBounds = YES;
    self.photo.layer.cornerRadius = 5;
#ifdef TEACHER_VERSION
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnPhoto:)];
    [self.photo addGestureRecognizer:tapGesture];
#endif
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickOnPhoto:(id)sender {
    [self.delegate clickOnPhoto:self];
}

- (void)drawRect:(CGRect)rect {
    // 绘制虚线
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0].CGColor);
    CGFloat lengths[] = {2,5};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 94.0, 94.0);
    CGContextAddLineToPoint(context, self.frame.size.width, 94.0);
    CGContextMoveToPoint(context, 94.0, 136.0);
    CGContextAddLineToPoint(context, self.frame.size.width, 134.0);
    CGContextStrokePath(context);
}

@end
