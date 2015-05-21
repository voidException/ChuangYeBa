//
//  TeacherTestGroupCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TeacherTestGroupCell.h"
#import "TestGroup.h"



@implementation TeacherTestGroupCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.publishButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGNormal"] forState:UIControlStateNormal];
    [self.publishButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGSelected"] forState:UIControlStateSelected];
    [self.publishButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGDisable"] forState:UIControlStateDisabled];
    [self.resultButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGNormal"] forState:UIControlStateNormal];
    [self.resultButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGSelected"] forState:UIControlStateHighlighted];
    [self.resultButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBGDisable"] forState:UIControlStateDisabled];
    
    [self.deleteButton setImage:[[UIImage imageNamed:@"deleteButtonNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.deleteButton setImage:[[UIImage imageNamed:@"deleteButtonHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    
}

- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setFill];
    float margin = 8.0;
    CGRect whiteFrame = CGRectMake(margin, 0, self.frame.size.width - 2 * margin, self.frame.size.height);
    UIRectFill(whiteFrame);
    
    [[UIColor clearColor] setStroke];
    CGRect frame = CGRectMake(0, 52, self.frame.size.width, 1);
    UIRectFrame(frame);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setState:(TestGroupState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case TestGroupStatepublish:
            _publishButton.enabled = YES;
            [_publishButton setTitle:@"取消发布" forState:UIControlStateNormal];
            _resultButton.enabled = YES;
            break;
        case TestGroupStateUnpublish:
            _publishButton.enabled = YES;
            [_publishButton setTitle:@"发布题组" forState:UIControlStateNormal];
            _resultButton.enabled = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([_testGroup.activity isEqual:@0]) {
        [self setState:TestGroupStateUnpublish];
    } else if ([_testGroup.activity isEqual:@1]) {
        [self setState:TestGroupStatepublish];
    }
    _titleLabel.text = _testGroup.itemTitle;
}


#pragma mark - Action
- (IBAction)clickOnPublishButton:(id)sender {
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:0];
}

- (IBAction)clickOnResultButton:(id)sender {
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:1];
}

- (IBAction)clickOnDeleteButton:(id)sender {
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:2];
}
@end
