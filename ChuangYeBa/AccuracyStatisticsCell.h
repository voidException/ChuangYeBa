//
//  AccuracyStatisticsCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccuracyBarView.h"

@interface AccuracyStatisticsCell : UITableViewCell

@property (strong, nonatomic) AccuracyBarView *accuracyBarView;
@property (strong, nonatomic) NSDictionary *quizStatistics;
@property (strong, nonatomic) UILabel *accuracyLabel;
@property (nonatomic) float accuracy;

- (void)beginAnimate;

@end
