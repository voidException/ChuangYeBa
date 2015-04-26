//
//  NewQuestionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)awakeFromNib {
    
    
    self.userInteractionEnabled = NO;
    
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = nil;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:83.0/255 green:84.0/255 blue:85.0/255 alpha:1.0]};
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
