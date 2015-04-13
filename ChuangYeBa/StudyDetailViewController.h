//
//  StudyDetailViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCell.h"
#import "MediaCell.h"
#import "CommentCell.h"

#define kAvatarSize 10.0
#define kMinimumHeight 40.0

#define ArticleSection 0
#define MediaSection 1
#define CommentSection 2

@interface StudyDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textInputBar;
@property (strong, nonatomic) NSMutableArray *userComment;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTitle;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfArtical;


- (IBAction)clickOnSendButton:(id)sender;

@end
