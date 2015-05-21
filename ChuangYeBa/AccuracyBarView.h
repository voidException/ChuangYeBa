//
//  AccuracyBarView.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AccuracyBarState) {
    AccuracyBarStateRed,
    AccuracyBarStateYellow,
    AccuracyBarStateGreen
};

@interface AccuracyBarView : UIView

@property(nonatomic) UIView *indicatorView;
@property (nonatomic) AccuracyBarState status;
@property (strong, nonatomic) UILabel *accuracyLabel;
@property (nonatomic) float accuracy;
@property (nonatomic) NSInteger accrateNum;
@property (nonatomic) NSInteger wholeNum;

- (void)beginAnimate;

@end
