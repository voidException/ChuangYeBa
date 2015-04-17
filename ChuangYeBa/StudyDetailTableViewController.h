//
//  StudyDetailTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCell.h"
#import "ArticleTitleCell.h"
#import "CommentCell.h"
#import "CountingCell.h"
#import "MediaCell.h"
#import "ArticleInfo.h"
#import "CommentInputView.h"

@interface StudyDetailTableViewController : UITableViewController <CommentInputViewDelegate>

@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (weak, nonatomic) CommentInputView *commentInputView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downLoadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeButton;
@property (strong, nonatomic) UIView *activityBackgroundView;
- (IBAction)clickOnCommentButton:(id)sender;
- (IBAction)clickOnLikeButton:(id)sender;

@end
