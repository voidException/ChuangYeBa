//
//  NewOptionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//


#import "OptionCell.h"

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

- (void)setState:(OptionCellState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    switch (state) {
        case OptionCellStateUnselected:
            checkLabel.textColor = [UIColor blueColor];
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
