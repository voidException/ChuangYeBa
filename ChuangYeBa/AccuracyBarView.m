//
//  AccuracyBarView.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AccuracyBarView.h"



@implementation AccuracyBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        _accuracy = 0;
        [self addIndicatorView];
        [self addAccuracyLabel];
    }
    return self;
}

#pragma mark - Property Setters

- (void)setAccuracy:(float)accuracy {
    if (accuracy == _accuracy) {
        return;
    }
    _accuracy = accuracy;
    if (accuracy > 0.8 && accuracy <= 1) {
        self.status = AccuracyBarStateGreen;
    } else if (accuracy > 0.6 && accuracy <= 0.8) {
        self.status = AccuracyBarStateYellow;
    } else {
        self.status = AccuracyBarStateRed;
    }
}

- (void)beginAnimate {
    float accuracy = 0;
    if (_wholeNum != 0) {
        accuracy = (float)_accrateNum/_wholeNum;
    } else {
        accuracy = 0;
    }
    
    if (accuracy > 0.85 && accuracy <= 1) {
        self.status = AccuracyBarStateGreen;
    } else if (accuracy > 0.5 && accuracy <= 0.85) {
        self.status = AccuracyBarStateYellow;
    } else {
        self.status = AccuracyBarStateRed;
    }
    
    _accuracyLabel.text = [NSString stringWithFormat:@"%lu/%lu", _accrateNum, _wholeNum];
   [self animateIndicatorViewToStatus:accuracy];
}

#pragma mark - Private Instance methods

- (void)animateIndicatorViewToStatus:(float)accuracy
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            *stop = YES;
            [self removeConstraint:constraint];
        }
    }];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:accuracy
                                                      constant:0]];
    if (accuracy < 0.1) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:0.2
                                                          constant:0]];
    } else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:accuracy
                                                      constant:-5.f]];
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
        [self layoutIfNeeded];
        self.indicatorView.backgroundColor = [self barColorForStatus:_status];
        self.accuracyLabel.textColor = [self textColorForStates:_status];
    } completion:NULL];
    
}

- (UIColor *)barColorForStatus:(AccuracyBarState)status
{
    switch (status) {
        case AccuracyBarStateRed:
            return [UIColor colorWithRed:0.989 green:0.378 blue:0.328 alpha:1.000];
        case AccuracyBarStateYellow:
            return [UIColor colorWithRed:1.000 green:0.706 blue:0.000 alpha:1.000];
        case AccuracyBarStateGreen:
            return [UIColor colorWithRed:0.620 green:0.902 blue:0.000 alpha:1.000];
        default:
            return [UIColor whiteColor];
    }
}

- (UIColor *)textColorForStates:(AccuracyBarState)status
{
    switch (status) {
        case AccuracyBarStateRed:
            return [UIColor whiteColor];
        case AccuracyBarStateYellow:
            return [UIColor whiteColor];
        case AccuracyBarStateGreen:
            return [UIColor whiteColor];
        default:
            return [UIColor whiteColor];
    }
}

- (void)addIndicatorView
{
    self.indicatorView = [UIView new];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.indicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.f
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:_accuracy
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0.f]];
}

- (void)addAccuracyLabel {
    self.accuracyLabel = [UILabel new];
    self.accuracyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.accuracyLabel];
    self.accuracyLabel.textColor = [UIColor grayColor];
    self.accuracyLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.accuracyLabel.shadowOffset = CGSizeMake(0.2, 0.2);
    self.accuracyLabel.shadowColor = [UIColor whiteColor];
    self.accuracyLabel.textAlignment = NSTextAlignmentRight;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:0.f]];
}



@end
