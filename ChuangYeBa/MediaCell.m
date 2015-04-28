//
//  MediaCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MediaCell.h"

@implementation MediaCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickOnMediaButton:(id)sender {
    [self.delegate clickOnMedia:self];
}

- (void)setState:(MediaCellState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case MediaCellStateNormal:
            self.centerImage.hidden = YES;
            self.smallImage.hidden = YES;
            break;
        case MediaCellStateLongImage:
            self.centerImage.hidden = YES;
            self.smallImage.hidden = NO;
            break;
        case MediaCellStateVideo:
            self.centerImage.hidden = NO;
            self.smallImage.hidden = YES;
            break;
    }
}

@end
