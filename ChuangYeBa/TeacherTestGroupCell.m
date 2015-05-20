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
            _publishButton.enabled = NO;
            _resultButton.enabled = YES;
            break;
        case TestGroupStateUnpublish:
            _publishButton.enabled = YES;
            _resultButton.enabled = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([_testGroup.activity isEqual:@0]) {
        [self setState:TestGroupStatepublish];
    } else if ([_testGroup.activity isEqual:@1]) {
        [self setState:TestGroupStatepublish];
    }
    _titleLabel.text = _testGroup.itemTitle;
}


#pragma mark - Action
- (IBAction)clickOnPublishButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认发布该题组吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:0];
}

- (IBAction)clickOnResultButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"啦啦啦" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [actionSheet showInView:self];
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:1];
}

- (IBAction)clickOnDeleteButton:(id)sender {
    [self.delegate teacherTestGroupCell:self clickOnButtonAtIndex:2];
}
@end
