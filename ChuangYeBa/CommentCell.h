//
//  CommentCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/5.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//


#import <UIKit/UIKit.h>

@class CommentInfo;
@class CommentCell;

@protocol CommentCellDelegate <NSObject>

- (void)clickOnCommentCellDeleteButton:(CommentCell *)commentCell;

@end

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) id <CommentCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)clickOnDeleteButton:(id)sender;

@property (strong, nonatomic) CommentInfo *commentInfo;


@end
