//
//  ClassInfoCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassInfoCell.h"

@implementation ClassInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickOnAddAndSettingButton:(id)sender {
    [self.delegate userClickOnaddAndSettingButton:self];
}
@end
