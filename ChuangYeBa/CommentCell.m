//
//  CommentCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/5.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CommentCell.h"
#import "CommentInfo.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.commentTextView.editable = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.commentTextView.scrollEnabled = NO;
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 4;
}

- (void)layoutSubviews {
    self.userInfoLabel.text = self.commentInfo.userName;
    self.commentTextView.text = self.commentInfo.content;
    if ([self.commentInfo.userPhotoPath class] == [NSNull class]) {
        [self.photoImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"photoPlaceholderBig"]];
    } else {
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:self.commentInfo.userPhotoPath] placeholderImage:[UIImage imageNamed:@"photoPlaceholderBig"]];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 由于后台原因，这里只能显示到年月日
    [dateFormatter setDateFormat: @"yy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:self.commentInfo.commentTime];
    self.dateLabel.text = date;
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

#pragma CommentCell Delegate
- (IBAction)clickOnDeleteButton:(id)sender {
    [self.delegate clickOnCommentCellDeleteButton:self];
}
@end
