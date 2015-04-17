//
//  MediaCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton;

@property (weak, nonatomic) IBOutlet UIButton *clickOnMediaButton;


@end
