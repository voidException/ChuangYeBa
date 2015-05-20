//
//  AccuracyStatisticsCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AccuracyStatisticsCell.h"

@implementation AccuracyStatisticsCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addAccuracyBarView];
    
    _quizStatistics = [[NSDictionary alloc] init];
    
}

- (void)showAccuracy {
    NSNumber *accrateNum = [_quizStatistics objectForKey:@"accurateNum"];
    NSNumber *wholeNum = [_quizStatistics objectForKey:@"wholeNum"];
    NSNumber *testNo = [_quizStatistics objectForKey:@"testNo"];
    
    if ([wholeNum integerValue] != 0) {
        _accuracy = (float)[accrateNum integerValue]/[wholeNum integerValue];
    } else {
        _accuracy = 0;
    }
    _accuracyBarView.accuracy = _accuracy;
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
                               constraintsWithVisualFormat:@"V:|-[_accuracyBarView]-|"
                               options:0
                               metrics:nil
                               views:views]];
    
}


@end
