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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor]};
    self.content.attributedText = [[NSAttributedString alloc] initWithString:self.content.text attributes:attributes];
}


@end
