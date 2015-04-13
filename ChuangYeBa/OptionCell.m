//
//  OptionCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "OptionCell.h"

@implementation OptionCell

@synthesize heightOfTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        
        self.textView.userInteractionEnabled = NO;
        self.textView.editable = NO;

        self.textView.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.textView];
        self.textView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(36, 0, screenWidth - 36, heightOfTextView);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
