//
//  DownloadProgressCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/6/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "DownloadProgressCell.h"
#import "GlobalDefine.h"

@implementation DownloadProgressCell

- (void)awakeFromNib {
    self.state = DownloadCellStateDownloading;
}

- (void)setState:(DownloadCellState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case DownloadCellStateConnecting:
            _speedLabel.hidden = NO;
            _sizeLabel.hidden = NO;
            _stateLabel.hidden = YES;
            _stateLabel.text = @"正在连接";
            _stateLabel.textColor = [UIColor grayColor];
            _progressView.progressTintColor = [UIColor CYBBlueColor];
        case DownloadCellStateDownloading:
            _speedLabel.hidden = NO;
            _sizeLabel.hidden = NO;
            _stateLabel.hidden = YES;
            _progressView.progressTintColor = [UIColor CYBBlueColor];
            break;
        case DownloadCellStateFailed:
            _speedLabel.hidden = YES;
            _sizeLabel.hidden = YES;
            _stateLabel.hidden = NO;
            _stateLabel.text = @"网络错误";
            _stateLabel.textColor = [UIColor redColor];
            _progressView.progressTintColor = [UIColor redColor];
            break;
        case DownloadCellStatePause: 
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1] setStroke];
    CGRect frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 2);
    UIRectFrame(frame);
}

@end
