//
//  NewQuestionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell
@synthesize heightOfTextView;

/*
- (id)init {
    self = [super init];
    if (self) {
        self.textView.frame = CGRectMake(0, 0, screenWidth, 0);
    }
    return self;
}
 */

- (void)awakeFromNib {
    
    
    self.userInteractionEnabled = NO;
    
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.textView.frame = CGRectMake(0, 0, screenWidth, heightOfTextView);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
