//
//  ArticleCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/5.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (void)awakeFromNib {
    
    self.article.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.article.font = [UIFont systemFontOfSize:14.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
