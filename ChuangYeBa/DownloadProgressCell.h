//
//  DownloadProgressCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/6/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DownloadCellStateConnecting = 1,
    DownloadCellStateDownloading,
    DownloadCellStateFailed,
    DownloadCellStatePause,
} DownloadCellState;

@interface DownloadProgressCell : UITableViewCell

@property (nonatomic, assign) DownloadCellState state;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
