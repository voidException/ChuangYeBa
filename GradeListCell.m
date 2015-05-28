//
//  GradeListCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "GradeListCell.h"

@implementation GradeListCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
