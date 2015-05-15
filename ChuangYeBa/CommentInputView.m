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
    [self.sendButton setTitleColor:[UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithRed:124.0/255 green:124.0/255 blue:124.0/255 alpha:1] forState:UIControlStateDisabled];
    
    
    if (!self.textView.text.length) {
        self.sendButton.enabled = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    //[[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    CGRect tfFrame = self.textView.frame;
    [[UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(tfFrame.origin.x - 1, tfFrame.origin.y - 1, tfFrame.size.width + 2, tfFrame.size.height + 2);
    UIRectFrame(frame);
    
    CGRect selfFrame = self.frame;
    [[UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1] setStroke];
    frame = CGRectMake(0, 0, selfFrame.size.width, selfFrame.size.height);
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
