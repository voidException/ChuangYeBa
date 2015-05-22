//
//  ClassListCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassListCell.h"

@implementation ClassListCell

- (void)awakeFromNib {
    _photoImage.layer.masksToBounds = YES;
    _photoImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

@end
