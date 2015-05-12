//
//  StudyDetailViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/17.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyNetworkUtils.h"
#import "ArticleCell.h"
#import "ArticleTitleCell.h"
#import "CommentCell.h"
#import "CountingCell.h"
#import "MediaCell.h"
#import "ArticleInfo.h"
#import "UserInfo.h"
#import "CommentInputView.h"
#import "CommentInfo.h"
#import "FXBlurView.h"

@interface StudyDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CommentInputViewDelegate, CommentCellDelegate, MediaCellDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (strong, nonatomic) UserInfo *userInfo;

@property (weak, nonatomic) CommentInputView *commentInputView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) UINavigationItem *customItem;
@property (strong, nonatomic) UINavigationBar *customBar;
@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isDownloaded;

@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSDictionary *comment;

@property (strong, nonatomic) FXBlurView *activityBackgroundView;
- (IBAction)clickOnCommentButton:(id)sender;
- (IBAction)clickOnLikeButton:(id)sender;
- (IBAction)clickOnDownloadButton:(id)sender;


@end
