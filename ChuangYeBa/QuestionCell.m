//
//  QuestionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "QuestionCell.h"


@implementation QuestionCell

@synthesize heightOfTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userInteractionEnabled = NO;

        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
        self.textView.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.textView];
        self.textView.backgroundColor = [UIColor clearColor];
        
        //self.testGroup = [[TestGroup alloc] init];
        self.textView.text = nil;
    }
    return self;
}

- (void)awakeFromNib {
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(0, 0, screenWidth, heightOfTextView);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
