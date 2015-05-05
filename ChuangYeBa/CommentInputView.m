//
//  commentInputView.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CommentInputView.h"

@implementation CommentInputView


- (void)awakeFromNib {
    self.textView.delegate = self;
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    if (!self.textView.text.length) {
        self.sendButton.enabled = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    //[[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    CGRect tfFrame = self.textView.frame;
    [[UIColor grayColor] setStroke];
    CGRect frame = CGRectMake(tfFrame.origin.x - 1, tfFrame.origin.y - 1, tfFrame.size.width + 2, tfFrame.size.height + 2);
    UIRectFrame(frame);
}

- (IBAction)clickOnSendButton:(id)sender {
    [self.delegate commentInputView:self clickOnCommentButtonAtIndex:1];
}

- (IBAction)clickOnCancelButton:(id)sender {
    [self.delegate commentInputView:self clickOnCommentButtonAtIndex:0];
}

#pragma mark - Text View Delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.textView.text.length) {
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
}

@end
