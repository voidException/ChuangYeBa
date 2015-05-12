//
//  StudyContentCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentCell.h"

@implementation StudyContentCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(20, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

@end
