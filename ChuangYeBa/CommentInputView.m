//
//  commentInputView.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CommentInputView.h"

@implementation CommentInputView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //[[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    
    [[UIColor greenColor] setStroke];
    CGRect frame = CGRectMake(15, 42, [UIScreen mainScreen].bounds.size.width, 93);
    UIRectFrame(frame);
}


- (IBAction)clickOnSendButton:(id)sender {
    [self.delegate commentInputView:self clickOnCommentButtonAtIndex:1];
}

- (IBAction)clickOnCancelButton:(id)sender {
    [self.delegate commentInputView:self clickOnCommentButtonAtIndex:0];
}
@end
