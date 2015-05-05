//
//  PullUpRefreshView.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PullUpRefreshViewStateIdle = 1, // 普通闲置状态
    PullUpRefreshViewStateRefreshing, // 正在刷新中的状态
    PullUpRefreshViewStateNoMoreData // 所有数据加载完毕，没有更多的数据了
} PullUpRefreshViewState;

@interface PullUpRefreshView : UIView


@property (copy, nonatomic) void (^refreshingBlock)();
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;
@property (nonatomic) PullUpRefreshViewState state;

- (void)addPullUpRefreshingBlock:(void (^)())block;

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;
- (void)noticeNoMoreData;
- (void)resetNoMoreData;

@end
