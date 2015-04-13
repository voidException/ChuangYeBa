//
//  NewOptionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "NewOptionCell.h"

@implementation NewOptionCell

- (void)awakeFromNib {
    // Initialization code
    self.textView.userInteractionEnabled = NO;
    self.checkImage.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.highlighted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
