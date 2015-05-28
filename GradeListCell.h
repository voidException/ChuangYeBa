//
//  GradeListCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleImageView.h"

@interface GradeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CircleImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@end
