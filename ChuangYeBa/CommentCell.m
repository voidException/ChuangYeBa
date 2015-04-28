//
//  CommentCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/5.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.commentTextView.editable = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 15;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

@end
