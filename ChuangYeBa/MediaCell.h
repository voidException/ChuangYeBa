//
//  MediaCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MediaCellStateNormal = 1,
    MediaCellStateLongImage = 2,
    MediaCellStateVideo
} MediaCellState;

@class MediaCell;

@protocol MediaCellDelegate

- (void)clickOnMedia:(MediaCell *)mediaCell;

@end

@interface MediaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton;

@property (assign, nonatomic) MediaCellState state;

- (IBAction)clickOnMediaButton:(id)sender;


@property (weak, nonatomic) id <MediaCellDelegate> delegate;


@end
