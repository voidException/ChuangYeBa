//
//  CountingCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likeCountingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountingLabel;

@end
