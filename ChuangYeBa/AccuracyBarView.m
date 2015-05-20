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
        self.layer.cornerRadius = 15.f;
        _accuracy = 0;
        [self addIndicatorView];
    }
    return self;
}

#pragma mark - Property Setters

- (void)setStatus:(AccuracyBarState)status
{
    if (status == _status) {
        return;
    }
    _status = status;
    [self animateIndicatorViewToStatus:status];
}

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
    [self animateIndicatorViewToStatus:_status];
    
}

#pragma mark - Private Instance methods

- (void)animateIndicatorViewToStatus:(AccuracyBarState)status
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
                                                    multiplier:_accuracy
                                                      constant:0]];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
        [self layoutIfNeeded];
        self.indicatorView.backgroundColor = [self colorForStatus:status];
    } completion:NULL];
    
}

/*
- (CGFloat)multiplierForStatus:(AccuracyBarState)status
{
    switch (status) {
        case AccuracyBarStateRed:
            return 0.33f;
        case AccuracyBarStateYellow:
            return 0.66f;
        case AccuracyBarStateGreen:
            return 1.f;
        default:
            return 0.f;
    }
}
*/

- (UIColor *)colorForStatus:(AccuracyBarState)status
{
    switch (status) {
        case AccuracyBarStateRed:
            return [UIColor redColor];
        case AccuracyBarStateYellow:
            return [UIColor yellowColor];
        case AccuracyBarStateGreen:
            return [UIColor greenColor];
        default:
            return [UIColor whiteColor];
    }
}

- (void)addIndicatorView
{
    self.indicatorView = [UIView new];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.layer.cornerRadius = self.layer.cornerRadius;
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



@end
