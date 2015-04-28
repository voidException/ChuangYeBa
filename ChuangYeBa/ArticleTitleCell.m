//
//  ArticleTitleCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleTitleCell.h"

@implementation ArticleTitleCell

- (void)awakeFromNib {
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor]};
    self.title.attributedText = [[NSAttributedString alloc] initWithString:self.title.text attributes:attributes];
}


@end
