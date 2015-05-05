//
//  PullUpRefreshView.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "PullUpRefreshView.h"



@implementation PullUpRefreshView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [[UIButton alloc] initWithFrame:frame];
        //[self.button setTitle: forState:UIControlStateNormal];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor grayColor]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"点击加载更多评论" attributes:attributes];
        [self.button setAttributedTitle:attributedString forState:UIControlStateNormal];
    
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(clickOnRefreshButton) forControlEvents:UIControlEventTouchUpInside];
        self.button.center = self.center;
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.center = self.center;
        
        self.label = [[UILabel alloc] initWithFrame:frame];
        self.label.center = self.center;
        self.label.text = @"没有更多评论了";
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.button];
        [self addSubview:self.indicator];
        [self addSubview:self.label];
        
        self.state = PullUpRefreshViewStateIdle;
        }
    return self;
}




#pragma mark - Private Method
- (void)setState:(PullUpRefreshViewState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    switch (state) {
        case PullUpRefreshViewStateIdle:
            self.button.hidden = NO;
            self.indicator.hidden = YES;
            self.label.hidden = YES;
            [self.indicator stopAnimating];
            break;
        case PullUpRefreshViewStateRefreshing:
            self.button.hidden = YES;
            self.indicator.hidden = NO;
            self.label.hidden = YES;
            if (self.refreshingBlock) {
                self.refreshingBlock();
            }
            [self.indicator startAnimating];
            break;
        case PullUpRefreshViewStateNoMoreData:
            self.button.hidden = YES;
            self.indicator.hidden = YES;
            self.label.hidden = NO;
            [self.indicator stopAnimating];
            break;
    }
}

- (void)clickOnRefreshButton {
    self.state = PullUpRefreshViewStateRefreshing;
}


#pragma mark - Public Method
- (void)addPullUpRefreshingBlock:(void (^)())block
{
    self.refreshingBlock = block;
}

- (void)beginRefreshing
{
    self.state = PullUpRefreshViewStateRefreshing;
}

- (void)endRefreshing
{
    self.state = PullUpRefreshViewStateIdle;
}

- (BOOL)isRefreshing
{
    return self.state == PullUpRefreshViewStateRefreshing;
}

- (void)noticeNoMoreData
{
    self.state = PullUpRefreshViewStateNoMoreData;
}

- (void)resetNoMoreData
{
    self.state = PullUpRefreshViewStateIdle;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
