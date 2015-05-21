//
//  AccuracyStatisticsCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AccuracyStatisticsCell.h"

@implementation AccuracyStatisticsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addAccuracyBarView];
        
        self.quizStatistics = [[NSDictionary alloc] init];
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    }
    return self;
}

- (void)setQuizStatistics:(NSDictionary *)quizStatistics {
    if (quizStatistics == _quizStatistics) {
        return;
    }
    _quizStatistics = quizStatistics;
    
    _accuracyBarView.accrateNum = [[_quizStatistics objectForKey:@"accurateNum"] integerValue];
    _accuracyBarView.wholeNum = [[_quizStatistics objectForKey:@"wholeNum"]integerValue];
    NSNumber *testNo = [_quizStatistics objectForKey:@"testNo"];
    self.textLabel.text = [NSString stringWithFormat:@"%@.", testNo];
}

- (void)beginAnimate {
    [_accuracyBarView beginAnimate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addAccuracyBarView {
    self.accuracyBarView = [AccuracyBarView new];
    [self addSubview:self.accuracyBarView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_accuracyBarView);
    
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-40-[_accuracyBarView]-40-|"
                               options:0
                               metrics:nil
                               views:views]];
    
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-10-[_accuracyBarView]-10-|"
                               options:0
                               metrics:nil
                               views:views]];
    
}

@end
