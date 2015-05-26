//
//  StudyContentCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentCell.h"
#import "GlobalDefine.h"

@implementation StudyContentCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //self.contentView addConstraint:[]
        //[self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (iPhone4 || iPhone5) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.introductionLabel.font = [UIFont systemFontOfSize:12];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introductionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (iPhone5 || iPhone4) {
        [paragraphStyle setLineSpacing:1.0];
    } else {
        [paragraphStyle setLineSpacing:4.0];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.introductionLabel.text.length)];
    self.introductionLabel.attributedText = attributedString;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(20, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

@end
