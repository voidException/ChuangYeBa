//
//  commentInputView.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentInputView;
@protocol CommentInputViewDelegate

- (void) commentInputView:(CommentInputView *)commentInputView clickOnCommentButtonAtIndex:(NSInteger)index;

@end

@interface CommentInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak,nonatomic) id <CommentInputViewDelegate> delegate;

- (IBAction)clickOnSendButton:(id)sender;
- (IBAction)clickOnCancelButton:(id)sender;

@end
