//
//  ExplainCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/12.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ExplainCell.h"

@implementation ExplainCell

- (void)awakeFromNib {
    self.userInteractionEnabled = NO;
    [self setState:ExplainCellStateCorrect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:81.0/255 green:82.0/255 blue:83.0/255 alpha:1.0], NSParagraphStyleAttributeName:paragraphStyle};
    self.explainTextView.attributedText = [[NSAttributedString alloc] initWithString:self.explainTextView.text attributes:attributes];
}


- (void)setState:(ExplainCellState)state {
    if (_state == state) {
        return;
    }
    
    _state = state;
    
    switch (state) {
        case ExplainCellStateCorrect:
            self.leftLabel.text = @"回答正确。";
            self.anwserLabel.hidden = YES;
            self.rightLabel.hidden = YES;
            self.optionLabel.hidden = YES;
            break;
        case ExplainCellStateError:
            self.leftLabel.text = @"正确答案是";
            self.anwserLabel.hidden = NO;
            self.rightLabel.hidden = NO;
            self.optionLabel.hidden = NO;
            break;
    }
}


@end
