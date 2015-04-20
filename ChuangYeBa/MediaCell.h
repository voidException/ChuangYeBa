//
//  MediaCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MediaCell;

@protocol MediaCellDelegate

- (void)clickOnMedia:(MediaCell *)mediaCell;

@end

@interface MediaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton;

- (IBAction)clickOnMediaButton:(id)sender;


@property (weak, nonatomic) id <MediaCellDelegate> delegate;


@end
