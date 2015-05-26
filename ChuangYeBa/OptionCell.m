//
//  NewOptionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//


#import "OptionCell.h"


#define THEME_BLUE colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1

@implementation OptionCell

@synthesize textLabel;
@synthesize checkLabel;
@synthesize checkImage;


- (void)awakeFromNib {
    self.textView.userInteractionEnabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.state = OptionCellStateUnable;
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
    //self.textView.textColor = [UIColor redColor];
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
}

- (void)setState:(OptionCellState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    switch (state) {
        case OptionCellStateUnselected:
            checkLabel.textColor = [UIColor THEME_BLUE];
            checkImage.image = [UIImage imageNamed:@"optionIconBlueCircle"];
            break;
        case OptionCellStateSelected:
            checkLabel.textColor = [UIColor whiteColor];
            checkImage.image = [UIImage imageNamed:@"optionIconBlue"];
            break;
        case OptionCellStateError:
            checkLabel.textColor = [UIColor whiteColor];
            checkImage.image = [UIImage imageNamed:@"optionIconRed"];
            break;
        case OptionCellStateCorrect:
            checkLabel.textColor = [UIColor whiteColor];
            checkImage.image = [UIImage imageNamed:@"optionIconGreen"];
            break;
        case OptionCellStateUnable:
            checkLabel.textColor = [UIColor grayColor];
            checkImage.image = [UIImage imageNamed:@"optionIconGrayCircle"];
            break;
    }
}


@end
